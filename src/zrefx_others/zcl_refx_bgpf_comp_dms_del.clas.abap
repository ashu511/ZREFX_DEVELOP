CLASS zcl_refx_bgpf_comp_dms_del DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_context,
             complaintid  TYPE c LENGTH 16,
             attachmentid TYPE sysuuid_x16,
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



CLASS ZCL_REFX_BGPF_COMP_DMS_DEL IMPLEMENTATION.


  METHOD if_bgmc_op_single~execute.

    DATA: lv_repo_id     TYPE string,
          ls_children    TYPE cmis_s_object_in_folder_list,
          lo_cmis_client TYPE REF TO if_cmis_client.

    IF mt_context_data IS INITIAL.
      RETURN.
    ENDIF.

* Get Client and Repository once outside the loop
    CALL METHOD cl_cmis_client_factory2=>get_instance
      RECEIVING
        ro_client = lo_cmis_client.

    " 1. Fetch Repository Configuration
    SELECT SINGLE config_value FROM zrefx_btp_config
      WHERE object_id = 'repository_id'
      INTO @lv_repo_id.

    IF lv_repo_id IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT mt_context_data INTO DATA(ls_ctx).
      " Ensure we have the dmsid (documentid) passed from SAVE_MODIFIED
      IF ls_ctx-documentid IS INITIAL.
        CONTINUE.
      ENDIF.

      TRY.
          " 2. Delete the Document directly from BTP DMS
          lo_cmis_client->delete(
            EXPORTING
              iv_repository_id = lv_repo_id
              iv_object_id     = ls_ctx-documentid
              iv_all_versions  = abap_true
          ).

          " 3. Cleanup: Check if the folder is empty
          " Get Folder ID by path (Complaint ID folder)
          DATA(lv_folder_path) = |/{ ls_ctx-complaintid }|.

          lo_cmis_client->get_object_by_path(
            EXPORTING
              iv_repository_id = lv_repo_id
              iv_path          = lv_folder_path
            IMPORTING
              es_object        = DATA(ls_folder_obj)
          ).

          " Extract technical Folder ID from properties
          READ TABLE ls_folder_obj-properties-properties INTO DATA(ls_prop)
               WITH KEY id = cl_cmis_property_ids=>object_id.
          READ TABLE ls_prop-value INTO DATA(lv_prop_val) INDEX 1.
          DATA(lv_folder_id) = lv_prop_val-string_value.

          " Check if any other files exist in this complaint's folder
          lo_cmis_client->get_children(
            EXPORTING
              iv_repository_id = lv_repo_id
              iv_folder_id     = lv_folder_id
            IMPORTING
              es_children      = ls_children
          ).

          " If no more files in DMS, delete the empty folder
          IF ls_children-objects_in_folder IS INITIAL.
            lo_cmis_client->delete_tree(
              EXPORTING
                iv_repository_id = lv_repo_id
                iv_object_id     = lv_folder_id
                iv_all_versions  = abap_false
            ).
          ENDIF.

        CATCH cx_cmis_object_not_found.
          " File or folder already gone - this is fine for a delete operation
          CONTINUE.
        CATCH cx_cmis_runtime.
          " Log error to bgPF monitor
          CONTINUE.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_context_data.

    mt_context_data = it_context.

  ENDMETHOD.
ENDCLASS.
