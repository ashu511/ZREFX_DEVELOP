CLASS lhc_ZREFX_I_COMPENSATION DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zrefx_i_compensation RESULT result.

    METHODS UpdateDivision FOR MODIFY
       keys FOR ACTION zrefx_i_compensation~UpdateDivision RESULT result.

    METHODS setInitialDate FOR DETERMINE ON MODIFY
       keys FOR zrefx_i_compensation~setInitialDate.

ENDCLASS.

CLASS lhc_ZREFX_I_COMPENSATION IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD UpdateDivision.
  ENDMETHOD.

  METHOD setInitialDate.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Attachments DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Attachments RESULT result.

    METHODS delete FOR MODIFY
       keys FOR ACTION Attachments~delete RESULT result.

    METHODS download FOR MODIFY
       keys FOR ACTION Attachments~download RESULT result.

    METHODS updateDmsId FOR MODIFY
       keys FOR ACTION Attachments~updateDmsId RESULT result.

ENDCLASS.

CLASS lhc_Attachments IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD updateDmsId.
    DATA lv_empty_content TYPE xstring.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      " This LOCAL MODE bypasses the UI lock!
      MODIFY ENTITIES OF zrefx_i_compensation IN LOCAL MODE
        ENTITY Attachments
        UPDATE FIELDS ( Dmsid Content )
        WITH VALUE #( ( CompensationId  = <ls_key>-CompensationId
                        AttachmentId = <ls_key>-AttachmentId
                        Dmsid        = <ls_key>-%param-documentid
                        Content      = lv_empty_content ) ).
    ENDLOOP.

    READ ENTITIES OF zrefx_i_compensation IN LOCAL MODE
      ENTITY Attachments ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_attachments).

    result = VALUE #( FOR att IN lt_attachments ( %tky = att-%tky %param = att ) ).
  ENDMETHOD.
  METHOD download.
* Get the CMIS Client
    DATA(lo_cmis_client) = cl_cmis_client_factory2=>get_instance( ).

    DATA : lv_repo_id    TYPE string,
           lv_documentid TYPE string.

* Download the object                                                                                     *
    SELECT SINGLE config_value
      FROM zrefx_btp_config
      WHERE object_id   = 'repository_id'
      INTO @lv_repo_id.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).

      lv_documentid = <ls_key>-%param-documentid.

      " Skip if no document ID was provided
      IF lv_documentid IS INITIAL.
        CONTINUE.
      ENDIF.

      TRY.
          " Attempt the download
          CALL METHOD lo_cmis_client->get_content_stream
            EXPORTING
              iv_repository_id = lv_repo_id
              iv_object_id     = lv_documentid
            IMPORTING
              es_content       = DATA(lv_content).

          " Pass value back to the front-end as response
          APPEND VALUE #(
           %cid   = <ls_key>-%cid
           %param = VALUE #( content = lv_content-stream )
           ) TO result.

          " Catch specifically if the file is missing/deleted
        CATCH cx_cmis_object_not_found.

          " Mark the action as failed for this specific key
          APPEND VALUE #( %cid = <ls_key>-%cid
                          %fail-cause = if_abap_behv=>cause-not_found ) TO failed-attachments.

          " Report a clean error message back to the UI5 application
          APPEND VALUE #( %cid = <ls_key>-%cid
                          %msg = new_message_with_text(
                                   text     = 'Document not found or already deleted in DMS.'
                                   severity = if_abap_behv_message=>severity-error )
                        ) TO reported-attachments.

          " Catch any other CMIS runtime errors (e.g., network timeout)
        CATCH cx_cmis_root INTO DATA(lx_cmis).

          APPEND VALUE #( %cid = <ls_key>-%cid
                          %fail-cause = if_abap_behv=>cause-not_found ) TO failed-attachments.

          APPEND VALUE #( %cid = <ls_key>-%cid
                          %msg = new_message_with_text(
                                   text     = 'Failed to download document from DMS.'
                                   severity = if_abap_behv_message=>severity-error )
                        ) TO reported-attachments.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.
  METHOD delete.
    DATA: lv_repo_id     TYPE string,
          ls_children    TYPE cmis_s_object_in_folder_list,
          lo_cmis_client TYPE REF TO if_cmis_client.

    SELECT SINGLE config_value FROM zrefx_btp_config
      WHERE object_id = 'repository_id'
      INTO @lv_repo_id.

    lo_cmis_client = cl_cmis_client_factory2=>get_instance( ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      DATA : lv_dmsid TYPE string.

      DATA(lv_CompensationId) = <ls_key>-%param-CompensationId.
      DATA(lv_attachmentid) = <ls_key>-%param-attachmentid.

      " 1. Read the DMS ID from the database using the provided keys
      READ ENTITIES OF zrefx_i_compensation IN LOCAL MODE
        ENTITY Attachments
        FIELDS ( Dmsid )
        WITH VALUE #( ( CompensationId = lv_CompensationId AttachmentId = lv_attachmentid ) )
        RESULT DATA(lt_attachments).

      IF lt_attachments IS INITIAL.
        CONTINUE.
      ENDIF.

      lv_dmsid = lt_attachments[ 1 ]-Dmsid.

      TRY.
          " 2. Delete from BTP DMS
          lo_cmis_client->delete(
            EXPORTING
              iv_repository_id = lv_repo_id
              iv_object_id     = lv_dmsid
              iv_all_versions  = abap_true ).

          " --- Folder Cleanup Logic ---
          DATA(lv_folder_path) = |/{ lv_CompensationId }|.
          lo_cmis_client->get_object_by_path(
            EXPORTING iv_repository_id = lv_repo_id
                      iv_path          = lv_folder_path
            IMPORTING es_object        = DATA(ls_folder_obj) ).

          DATA(lv_folder_id) = VALUE string( ls_folder_obj-properties-properties[ id = cl_cmis_property_ids=>object_id ]-value[ 1 ]-string_value OPTIONAL ).

          lo_cmis_client->get_children(
            EXPORTING iv_repository_id = lv_repo_id
                      iv_folder_id     = lv_folder_id
            IMPORTING es_children      = ls_children ).

          IF ls_children-objects_in_folder IS INITIAL.
            lo_cmis_client->delete_tree(
              EXPORTING iv_repository_id = lv_repo_id
                        iv_object_id     = lv_folder_id
                        iv_all_versions  = abap_false ).
          ENDIF.

        CATCH cx_cmis_root  ##NO_HANDLER.
          " Document might already be deleted in DMS, which is fine,
          " we still want to remove the orphaned record from SAP.
      ENDTRY.

      " 3. Delete the record from the RAP buffer (SAP Database)
      MODIFY ENTITIES OF zrefx_i_compensation IN LOCAL MODE
        ENTITY Attachments
          DELETE FROM VALUE #( ( CompensationId = lv_CompensationId AttachmentId = lv_attachmentid ) ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZREFX_I_WF_COMPNS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS updateParentStatus FOR DETERMINE ON MODIFY
       keys FOR zrefx_i_wf_compns~updateParentStatus.

ENDCLASS.

CLASS lhc_ZREFX_I_WF_COMPNS IMPLEMENTATION.

  METHOD updateParentStatus.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZREFX_I_COMPENSATION DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZREFX_I_COMPENSATION IMPLEMENTATION.

  METHOD adjust_numbers.
*-------------------------------------------------------------------------------*
* Get Next number using Number range Object for Claim Process
*-------------------------------------------------------------------------------*
    DATA lv_number_raw TYPE cl_numberrange_runtime=>nr_number. "value from number range



    LOOP AT mapped-zrefx_i_compensation ASSIGNING FIELD-SYMBOL(<fs_compensation>). "REFERENCE INTO DATA(map).
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = '01'
              object            = 'ZREFX_CPNR'
*              quantity          = 1
            IMPORTING
              number            = lv_number_raw
          ).
        CATCH cx_number_ranges INTO DATA(lx_error)  ##NO_HANDLER.

      ENDTRY.
      <fs_compensation>-CompensationId = |{ CONV i( lv_number_raw ) }|.
      DATA(current_date) = cl_abap_context_info=>get_system_date( ).
      DATA(current_year) = current_date(4).
      <fs_compensation>-CompensationId =  |{ 'CPN' } {  current_year } { <fs_compensation>-CompensationId }|.
      CONDENSE <fs_compensation>-CompensationId NO-GAPS.
    ENDLOOP.
* Attachments
    LOOP AT mapped-attachments ASSIGNING FIELD-SYMBOL(<lfs_att>).
      TRY.
          DATA(lv_attachid) = cl_system_uuid=>create_uuid_c32_static( ).
        CATCH cx_uuid_error.
          " Handle exception: Add message to reported or skip
          CONTINUE.
      ENDTRY.

      DATA(lv_CompensationId) = <lfs_att>-%tmp-CompensationId.

      <lfs_att>-CompensationId  = lv_CompensationId.
      <lfs_att>-AttachmentId = lv_attachid.

    ENDLOOP.
* Workflow Information
    " Generate UUIDs for new Workflow Log lines
    LOOP AT mapped-zrefx_i_wf_compns ASSIGNING FIELD-SYMBOL(<lfs_wf>).
      TRY.
          <lfs_wf>-LogUuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          CONTINUE.
      ENDTRY.
      <lfs_wf>-CompensationId = <lfs_wf>-%tmp-CompensationId.
    ENDLOOP.

  ENDMETHOD.

  METHOD save_modified.
    " Variables to Trigger the SBPA for created complaints
    DATA: lo_operation TYPE REF TO zcl_refx_bgpf_compns_sbpa,
          lo_process   TYPE REF TO if_bgmc_process_single_op,
          lx_bgmc      TYPE REF TO cx_bgmc.

    " Variables for DMS Background Process
    DATA: lo_dms_op     TYPE REF TO zcl_refx_bgpf_compns_dms_up,
          lt_dms_create TYPE zcl_refx_bgpf_compns_dms_up=>tt_context,
          lo_dms_del    TYPE REF TO zcl_refx_bgpf_dms_att_delete, "zcl_refx_bgpf_comp_dms_del,
          lt_dms_delete TYPE zcl_refx_bgpf_dms_att_delete=>tt_context.

    " Keep track of which complaints were officially 'Submitted' in this transaction
    DATA lt_submitted_compns TYPE TABLE OF zrefx_compns-compns_id.

    " For Create Scenario
    IF create-zrefx_i_compensation IS NOT INITIAL.

      LOOP AT create-zrefx_i_compensation INTO DATA(ls_compensation).

        " If the UI immediately passed '02' on creation
        IF ls_compensation-Status = '02'.

          APPEND ls_compensation-CompensationId TO lt_submitted_compns.

          TRY.
              " 1. Create an operation instance
              lo_operation = NEW zcl_refx_bgpf_compns_sbpa( ).

              " 2. Set the context data - this will be passed to the SBPA workflow
              " Get the current user's technical name and formatted name for the 'CreatedBy' and 'SubmittedBy' fields in the workflow context
              TRY.
                  DATA(lv_user_name) = cl_abap_context_info=>get_user_formatted_name( ).
                CATCH cx_abap_context_info_error ##NO_HANDLER.
                  "handle exception
              ENDTRY.

              lo_operation->set_context_data(
                                            compensationid      = ls_compensation-CompensationId
                                            compensationtype     = ls_compensation-Compensationtype
                                            compensationcategory = ls_compensation-Compensationcategory
                                            sourcechannel = ls_compensation-Sourcechannel
                                            compensationsubject  = ls_compensation-Compnssubject
                                            compensationamount   = ls_compensation-Compensationamount
                                            description   = ls_compensation-Detaileddescription
                                            status        = ls_compensation-Status
*                                            CreatedBy     = lv_user_name
                                            submittedby   = CONV string( ls_compensation-requestoremail ) "lv_user_name
                                            landid        = ls_compensation-Landid
                                            titledeed     = ls_compensation-Titledeedno
                                            vendoremail   = ls_compensation-Contactemail
                                            vendorname_en = ls_compensation-Vendorname
                                            vendorname_ar = ls_compensation-Vendorname
                                            submittedon   = ls_compensation-Createddate
                                           ).

              " 3. Get the bgPF process factory and create a process
              lo_process = cl_bgmc_process_factory=>get_default( )->create( ).

              " 4. Set a name for monitoring and inject the operation
              lo_process->set_name( 'CallClaimsBPA' )->set_operation( lo_operation ).

              " 5. Save for execution (the actual trigger happens after COMMIT)
              lo_process->save_for_execution( ).

            CATCH cx_bgmc INTO lx_bgmc ##NO_HANDLER.
              " Handle registration errors here
          ENDTRY.

        ENDIF.

      ENDLOOP.

    ENDIF.

    " HANDLE UPDATES (Draft to Submit Transition) ---
    IF update-zrefx_i_compensation IS NOT INITIAL.
      LOOP AT update-zrefx_i_compensation INTO DATA(ls_update).
        " Critical: Check if the UI *actually changed* the status to '02' during this update
        IF ls_update-%control-Status = if_abap_behv=>mk-on AND ls_update-Status = '02'.

          APPEND ls_update-CompensationId TO lt_submitted_compns.

          " We must read the full active record from the DB/Buffer to send to SBPA
          READ ENTITIES OF zrefx_i_compensation IN LOCAL MODE
            ENTITY zrefx_i_compensation ALL FIELDS WITH VALUE #( ( CompensationId = ls_update-CompensationId ) )
            RESULT DATA(lt_full_compensation).

          IF lt_full_compensation IS NOT INITIAL.
            DATA(ls_full) = lt_full_compensation[ 1 ].
            TRY.
                lo_operation = NEW zcl_refx_bgpf_compns_sbpa( ).
                lv_user_name = cl_abap_context_info=>get_user_formatted_name( ).
                lo_operation->set_context_data(
                                             compensationid      = ls_full-CompensationId
                                            compensationtype     = ls_full-Compensationtype
                                            compensationcategory = ls_full-Compensationcategory
                                            sourcechannel = ls_full-Sourcechannel
                                            compensationsubject  = ls_full-Compnssubject
                                            compensationamount   = ls_full-Compensationamount
                                            description   = ls_full-Detaileddescription
                                            status        = ls_full-Status
*                                            CreatedBy     = lv_user_name
                                            submittedby   = CONV string( ls_full-requestoremail ) "lv_user_name
                                            landid        = ls_full-Landid
                                            titledeed     = ls_full-Titledeedno
                                            vendoremail   = ls_full-Contactemail
                                            vendorname_en = ls_full-Vendorname
                                            vendorname_ar = ls_full-Vendorname
*                                            createddate   = ls_full-Createddate
                                            submittedon   = ls_full-Createddate
                ).
                lo_process = cl_bgmc_process_factory=>get_default( )->create( ).
                lo_process->set_name( 'CallClaimsBPA' )->set_operation( lo_operation )->save_for_execution( ).
              CATCH cx_root ##NO_HANDLER.
            ENDTRY.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " HANDLE DMS ATTACHMENT UPLOAD TRIGGER ---
    " If any complaints were officially submitted, we gather ALL their pending attachments
    IF lt_submitted_compns IS NOT INITIAL.

      READ ENTITIES OF zrefx_i_compensation IN LOCAL MODE
        ENTITY zrefx_i_compensation BY \_Attachments
        FIELDS ( CompensationId AttachmentId Content )
        WITH VALUE #( FOR comps IN lt_submitted_compns ( CompensationId = comps ) )
        RESULT DATA(lt_attachments_to_upload).

      LOOP AT lt_attachments_to_upload INTO DATA(ls_att).
        " Only trigger upload if there is physical file content in HANA
        " Only trigger upload if there is physical file content in HANA
        IF ls_att-Content IS NOT INITIAL.
          APPEND VALUE #( compensationId  = ls_att-CompensationId
                          attachmentid = ls_att-AttachmentId
                          content      = ls_att-Content
                          filename     = ls_att-Filename
                           mimetype    = ls_att-Mimetype
                         ) TO lt_dms_create.
        ENDIF.
      ENDLOOP.

      IF lt_dms_create IS NOT INITIAL.
        TRY.
            lo_dms_op = NEW zcl_refx_bgpf_compns_dms_up( ).

            lo_dms_op->set_context_data( it_context = lt_dms_create ).
            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentUpload' )->set_operation( lo_dms_op )->save_for_execution( ).
          CATCH cx_root ##NO_HANDLER.
        ENDTRY.
      ENDIF.

    ENDIF.

    IF create-attachments IS NOT INITIAL.

      " 1. Read the parent status to ensure we don't upload Draft files
      DATA lt_parent_keys TYPE TABLE FOR READ IMPORT zrefx_i_compensation.
      LOOP AT create-attachments ASSIGNING FIELD-SYMBOL(<ls_att_keys>).
        APPEND VALUE #( CompensationId = <ls_att_keys>-CompensationId ) TO lt_parent_keys.
      ENDLOOP.

      SORT lt_parent_keys BY CompensationId.
      DELETE ADJACENT DUPLICATES FROM lt_parent_keys COMPARING CompensationId.

      READ ENTITIES OF zrefx_i_compensation IN LOCAL MODE
        ENTITY zrefx_i_compensation FIELDS ( Status )
        WITH lt_parent_keys RESULT DATA(lt_parents).

      DATA lt_dms_create_api TYPE zcl_refx_bgpf_compns_dms_up=>tt_context.

      LOOP AT create-attachments ASSIGNING FIELD-SYMBOL(<lfs_attachment>).
        " Skip if there's no content to upload
        IF <lfs_attachment>-Content IS INITIAL.
          CONTINUE.
        ENDIF.

        " === GUARD 1: DOUBLE TRIGGER PREVENTION ===
        " If this complaint was JUST submitted in this transaction,
        " the lt_submitted_complaints block above already queued this file.
        IF line_exists( lt_submitted_compns[ table_line = <lfs_attachment>-CompensationId ] ).
          CONTINUE.
        ENDIF.

        " === GUARD 2: DRAFT PREVENTION ===
        " If the parent is still a Draft ('01' or blank), do not upload yet.
        READ TABLE lt_parents INTO DATA(ls_parent)
        WITH KEY entity COMPONENTS
        CompensationId = <lfs_attachment>-CompensationId.
        IF sy-subrc = 0 AND ( ls_parent-Status = '01' OR ls_parent-Status IS INITIAL ).
          CONTINUE.
        ENDIF.

        APPEND VALUE #(
          compensationId = <lfs_attachment>-CompensationId
          attachmentid = <lfs_attachment>-AttachmentId
          content      = <lfs_attachment>-Content
          filename     = <lfs_attachment>-Filename
          mimetype     = <lfs_attachment>-Mimetype
        ) TO lt_dms_create_api.
      ENDLOOP.

      " Only schedule BgPF if we have valid files to process
      IF lt_dms_create_api IS NOT INITIAL.
        TRY.
            DATA(lo_dms_op_api) = NEW zcl_refx_bgpf_compns_dms_up( ).
            lo_dms_op_api->set_context_data( it_context = lt_dms_create_api ).
            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentAPIUpload' )->set_operation( lo_dms_op_api )->save_for_execution( ).
          CATCH cx_bgmc INTO DATA(lx_bgmc_api) ##NO_HANDLER.
        ENDTRY.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
