CLASS zcl_refx_bgpf_dms_att_dwn DEFINITION
PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
    " Define a cache structure
    TYPES: BEGIN OF ty_cache,
             doc_id  TYPE string,
             content TYPE xstring,
           END OF ty_cache.
    " Static cache persists for the duration of the session
    CLASS-DATA mt_content_cache TYPE HASHED TABLE OF ty_cache WITH UNIQUE KEY doc_id.
ENDCLASS.



CLASS zcl_refx_bgpf_dms_att_dwn IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lo_cmis_client TYPE REF TO if_cmis_client,
          lv_repo_id     TYPE string.

    " Safety check to handle the generic table
    FIELD-SYMBOLS: <lt_original_data> TYPE INDEX TABLE.
    ASSIGN it_original_data TO <lt_original_data>.

    " Accessing components dynamically
    LOOP AT ct_calculated_data ASSIGNING FIELD-SYMBOL(<ls_calculated>).

      "Access the corresponding row in original data by index
      READ TABLE <lt_original_data> ASSIGNING FIELD-SYMBOL(<ls_original>) INDEX sy-tabix.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      ASSIGN COMPONENT 'DMSID' OF STRUCTURE <ls_original> TO FIELD-SYMBOL(<lv_doc_id>).
      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE <ls_calculated> TO FIELD-SYMBOL(<lv_content>).

      IF <lv_doc_id> IS ASSIGNED AND <lv_doc_id> IS NOT INITIAL.

        " 1. Check Cache First
        READ TABLE mt_content_cache ASSIGNING FIELD-SYMBOL(<ls_cache>)
             WITH TABLE KEY doc_id = <lv_doc_id>.

        IF sy-subrc = 0.
          <lv_content> = <ls_cache>-content.
        ELSE.
          " 2. Cache Miss - Fetch from DMS
          IF lo_cmis_client IS NOT BOUND.
            cl_cmis_client_factory2=>get_instance( RECEIVING ro_client = lo_cmis_client ).
            SELECT SINGLE config_value FROM zrefx_btp_config
              WHERE object_id = 'repository_id' INTO @lv_repo_id.
          ENDIF.

          " Explicitly convert the field symbol to a string
          DATA(lv_doc_id_string) = CONV string( <lv_doc_id> ).

          TRY.
              lo_cmis_client->get_content_stream(
                EXPORTING
                  iv_repository_id = lv_repo_id
                  iv_object_id     = lv_doc_id_string
                IMPORTING
                  es_content       = DATA(ls_stream)
              ).

              <lv_content> = ls_stream-stream.

              " 3. Store in Cache for next time
              INSERT VALUE #( doc_id = <lv_doc_id> content = ls_stream-stream )
                     INTO TABLE mt_content_cache.

            CATCH cx_cmis_root.
              " Log failure; content remains empty
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    APPEND 'DMSID' TO et_requested_orig_elements.
  ENDMETHOD.
ENDCLASS.
