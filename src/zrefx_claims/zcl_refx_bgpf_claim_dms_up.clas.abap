CLASS zcl_refx_bgpf_claim_dms_up DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_context,
             claimid  TYPE string,
             attachmentid TYPE sysuuid_x16,
             content      TYPE xstring,
             filename     TYPE string,
             mimetype     TYPE string,
             documentid   TYPE string,
           END OF ty_context,
           tt_context TYPE STANDARD TABLE OF ty_context WITH EMPTY KEY.

    METHODS set_context_data
      IMPORTING it_context TYPE tt_context.

    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single .

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA mt_context_data TYPE tt_context.

ENDCLASS.



CLASS zcl_refx_bgpf_claim_dms_up IMPLEMENTATION.


  METHOD if_bgmc_op_single~execute.

    DATA: lt_properties    TYPE cmis_t_client_property,
          ls_property      LIKE LINE OF lt_properties,
          lo_cmis_client   TYPE REF TO if_cmis_client,
          ls_value         LIKE LINE OF ls_property-values,
          ls_content       TYPE cmis_s_content_raw,
          lv_repo_id       TYPE string,
          lv_empty_content TYPE xstring.

    IF mt_context_data IS INITIAL.
      RETURN.
    ENDIF.

* Get Client and Repository once outside the loop
    CALL METHOD cl_cmis_client_factory2=>get_instance
      RECEIVING
        ro_client = lo_cmis_client.

    SELECT SINGLE config_value FROM zrefx_btp_config
      WHERE object_id = 'repository_id'
      INTO @lv_repo_id.

    lo_cmis_client->get_repository_info(
      EXPORTING iv_repository_id   = lv_repo_id
      IMPORTING es_repository_info = DATA(ls_repository) ).

* Group by Complaint ID to avoid redundant folder checks/creation
    DATA(ls_first_item) = mt_context_data[ 1 ].
    DATA(lv_folder_path) = |/{ ls_first_item-claimid }|.
    DATA(lv_folder_id) = VALUE string( ).

    TRY.

        lo_cmis_client->get_object_by_path(
          EXPORTING iv_repository_id = ls_repository-id
                    iv_path          = lv_folder_path
          IMPORTING es_object        = DATA(ls_folder) ).

      CATCH cx_cmis_object_not_found.

* Create folder if missing
        CLEAR lt_properties.
        APPEND VALUE #( id = cl_cmis_property_ids=>object_type_id
                        values = VALUE #( ( string_value = cl_cmis_constants=>base_type_id-cmis_folder ) ) ) TO lt_properties.
        APPEND VALUE #( id = cl_cmis_property_ids=>name
                        values = VALUE #( ( string_value = ls_first_item-claimid ) ) ) TO lt_properties.

        lo_cmis_client->create_folder(
          EXPORTING iv_repository_id = ls_repository-id
                    it_properties    = lt_properties
                    iv_folder_id     = ls_repository-root_folder_id
          IMPORTING es_object        = ls_folder ).

    ENDTRY.

* Get the Folder Internal ID
    lv_folder_id = VALUE #( ls_folder-properties-properties[ id = cl_cmis_property_ids=>object_id ]-value[ 1 ]-string_value OPTIONAL ).

    IF lv_folder_id IS INITIAL.
      RETURN. " Safety exit
    ENDIF.

* Document Creation Loop
    LOOP AT mt_context_data ASSIGNING FIELD-SYMBOL(<ls_ctx>).
      TRY.
          CLEAR: lt_properties, ls_content.

          "Add Properties
          APPEND VALUE #( id = cl_cmis_property_ids=>object_type_id
                          values = VALUE #( ( string_value = cl_cmis_constants=>base_type_id-cmis_document ) ) ) TO lt_properties.
          APPEND VALUE #( id = cl_cmis_property_ids=>name
                          values = VALUE #( ( string_value = <ls_ctx>-filename ) ) ) TO lt_properties.

          "Add Content
          ls_content-filename  = <ls_ctx>-filename.
          ls_content-mime_type = <ls_ctx>-mimetype.
          ls_content-stream    = <ls_ctx>-content.

          lo_cmis_client->create_document(
            EXPORTING iv_repository_id = ls_repository-id
                      it_properties    = lt_properties
                      is_content       = ls_content
                      iv_folder_id     = lv_folder_id
            IMPORTING es_object        = DATA(ls_new_doc) ).

* Extract and store the new Document ID back in the table.
          <ls_ctx>-documentid = VALUE #( ls_new_doc-properties-properties[ id = cl_cmis_property_ids=>object_id ]-value[ 1 ]-string_value OPTIONAL ).

* Update active Z table with DMS document ID
          IF <ls_ctx>-documentid IS NOT INITIAL.

            MODIFY ENTITIES OF zrefx_i_claims " Use your root entity name
              ENTITY Attachments
                UPDATE FIELDS ( Dmsid Content )
                WITH VALUE #( ( %tky-AttachmentId = <ls_ctx>-attachmentid
                                %tky-ClaimId      = <ls_ctx>-claimid
                                %is_draft         = if_abap_behv=>mk-off
                                dmsid             = <ls_ctx>-documentid
                                content           = lv_empty_content
                                ) )
              REPORTED DATA(lt_reported)
              FAILED DATA(lt_failed).

            IF lt_failed IS INITIAL.
*              COMMIT ENTITIES. " This is the key for background processes
            ENDIF.

          ENDIF.

        CATCH cx_cmis_root.
          " Log error but continue with next attachment
          CONTINUE.

      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD set_context_data.

    mt_context_data = it_context.

  ENDMETHOD.
ENDCLASS.
