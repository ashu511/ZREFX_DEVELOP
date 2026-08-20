CLASS lhc_zrefx_i_row_workflow_insta DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS updateParentStatus FOR DETERMINE ON MODIFY
      keys FOR ZREFX_I_ROW_WORKFLOW_INSTANCE~updateParentStatus.

ENDCLASS.

CLASS lhc_zrefx_i_row_workflow_insta IMPLEMENTATION.

  METHOD updateParentStatus.
      " 1. Read the newly created Workflow Info records from the RAP Buffer
    READ ENTITIES OF zrefx_i_row_request IN LOCAL MODE
      ENTITY zrefx_i_row_workflow_instance
      FIELDS ( RequestId CurrentStatus DecisionOutcome ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_wf_logs).

    DATA lt_parent_update TYPE TABLE FOR UPDATE zrefx_i_row_request.

    " 2. Evaluate the SBPA payload and determine the new parent status
    LOOP AT lt_wf_logs INTO DATA(ls_wf_log).

      DATA lv_new_parent_status TYPE string.
      CLEAR lv_new_parent_status.

      " Check if SBPA sent a final state (Rejection)
      IF ls_wf_log-CurrentStatus = 'REJECTED' OR ls_wf_log-CurrentStatus = 'REJECT'
         OR ls_wf_log-DecisionOutcome = 'REJECTED' OR ls_wf_log-DecisionOutcome = 'REJECT'.

        " Update this string to your exact GL Rejection Status code (e.g., 'REJT' or '04')
        lv_new_parent_status = 'REJECTED'.

        " Check if SBPA sent a final state (Approval)
      ELSEIF ls_wf_log-CurrentStatus = 'COMPLETED' OR ls_wf_log-DecisionOutcome = 'COMPLETED'
             OR ls_wf_log-DecisionOutcome = 'APPROVED'.

        " Update this string to your exact GL Approval Status code (e.g., 'APPR' or '03')
        lv_new_parent_status = 'APPROVED'.

      ENDIF.

      " Queue the parent for an update if a final state was reached
      IF lv_new_parent_status IS NOT INITIAL.
        APPEND VALUE #( %tky       = VALUE #( RequestId = ls_wf_log-RequestId )
                        Statuscode = lv_new_parent_status ) TO lt_parent_update.
      ENDIF.
    ENDLOOP.

    " 3. Remove duplicates (in case SBPA posted multiple logs simultaneously for the same request)
    IF lt_parent_update IS NOT INITIAL.
      SORT lt_parent_update BY %tky-RequestId.
      DELETE ADJACENT DUPLICATES FROM lt_parent_update COMPARING %tky-RequestId.
    ENDIF.

    " 4. Update the Parent GL Request using LOCAL MODE (bypasses UI read-only locks)
    IF lt_parent_update IS NOT INITIAL.
      MODIFY ENTITIES OF zrefx_i_row_request IN LOCAL MODE
        ENTITY Row
        UPDATE FIELDS ( Statuscode ) WITH lt_parent_update.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_attachments DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Attachments RESULT result.

    METHODS updateDmsId FOR MODIFY
       keys FOR ACTION Attachments~updateDmsId RESULT result.

ENDCLASS.

CLASS lhc_attachments IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateDmsId.
    DATA lv_empty_content TYPE xstring.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      " LOCAL MODE bypasses the UI lock to update Dmsid and wipe the HANA binary
      MODIFY ENTITIES OF zrefx_i_ROW_request IN LOCAL MODE
        ENTITY Attachments
        UPDATE FIELDS ( Dmsid Content )
        WITH VALUE #( ( RequestId         = <ls_key>-RequestId
                        AttachmentId      = <ls_key>-AttachmentId
                        Dmsid             = <ls_key>-%param-documentid
                        Content = lv_empty_content ) ).
    ENDLOOP.

    READ ENTITIES OF zrefx_i_row_request IN LOCAL MODE
      ENTITY Attachments ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_attachments).

    result = VALUE #( FOR att IN lt_attachments ( %tky = att-%tky %param = att ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zrefx_i_row_request DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS cleanup_finalize REDEFINITION.
    METHODS adjust_numbers REDEFINITION.
    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zrefx_i_row_request IMPLEMENTATION.

  METHOD cleanup_finalize.
  ENDMETHOD.

  METHOD adjust_numbers.
*-------------------------------------------------------------------------------*
* Get Next number using Number range Object for ROW Process
*-------------------------------------------------------------------------------*
    DATA lv_number_raw TYPE cl_numberrange_runtime=>nr_number. "value from number range
    DATA lv_number TYPE string.
    " Variables to Trigger the SBPA for created complaints


    LOOP AT mapped-row ASSIGNING FIELD-SYMBOL(<fs_row>). "REFERENCE INTO DATA(map).
      IF <fs_row>-RequestId IS INITIAL.
        TRY.
            cl_numberrange_runtime=>number_get(
              EXPORTING
                nr_range_nr       = '01'
                object            = 'ZREFX_RWNR'
*              quantity          = 1
              IMPORTING
                number            = lv_number_raw
            ).
          CATCH cx_number_ranges INTO DATA(lx_error)  ##NO_HANDLER.

        ENDTRY.
        lv_number = |{ CONV i( lv_number_raw ) }|.
        DATA(current_date) = cl_abap_context_info=>get_system_date( ).
        DATA(current_year) = current_date(4).
        lv_number  =  |{ 'ROW' } {  current_year } { lv_number  }|.
        CONDENSE  lv_number NO-GAPS.
        <fs_row>-RequestId = lv_number.
      ENDIF.
    ENDLOOP.

    " =====================================================================
    " 2. CHILD: Request Attachments
    " =====================================================================
    LOOP AT mapped-attachments ASSIGNING FIELD-SYMBOL(<lfs_att>).
      TRY.
          DATA(lv_attachid) = cl_system_uuid=>create_uuid_c32_static( ).
        CATCH cx_uuid_error.
          " Handle exception: Add message to reported or skip
          CONTINUE.
      ENDTRY.

      DATA(lv_RequestId) = <lfs_att>-%tmp-RequestId.

      <lfs_att>-RequestId  = lv_RequestId.
      <lfs_att>-AttachmentId = lv_attachid.

    ENDLOOP.
    " =====================================================================
    " 3. CHILD: Workflow Instance
    " =====================================================================
*    LOOP AT mapped-workflowinstance ASSIGNING FIELD-SYMBOL(<ls_wf>).
*
*      IF <ls_wf>-Objectid IS INITIAL.
*
*        TRY.
*            <ls_wf>-Objectid = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error.
*        ENDTRY.
*
*        <ls_wf>-RequestId = <ls_wf>-%tmp-RequestId.
*
*      ENDIF.
*
*    ENDLOOP.
  ENDMETHOD.
  METHOD save_modified.
 " =====================================================================
    " VARIABLE DECLARATIONS
    " =====================================================================
    " Variables for DMS Background Process
    DATA: lo_dms_op     TYPE REF TO zcl_refx_bgpf_row_dms_up,
          lt_dms_create TYPE zcl_refx_bgpf_row_dms_up=>tt_context.

    " Variables for SBPA Background Process
    DATA: lo_sbpa_op TYPE REF TO zcl_refx_bgpf_row_sbpa,
          lo_process TYPE REF TO if_bgmc_process_single_op,
          lx_bgmc    TYPE REF TO cx_bgmc.

    " Keep track of which ROW Land requests were officially 'Submitted' in this transaction
    DATA lt_submitted_requests TYPE TABLE OF zrefx_row-request_id.

    " =====================================================================
    " 1. TRACK SUBMISSIONS FROM 'CREATE'
    " =====================================================================
    IF create-row IS NOT INITIAL.
      LOOP AT create-row INTO DATA(ls_row_create).
        " If the UI immediately passed 'SUBM' on creation
        IF ls_row_create-Statuscode = '02'.
          APPEND ls_row_create-RequestId TO lt_submitted_requests.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " =====================================================================
    " 2. TRACK SUBMISSIONS FROM 'UPDATE' (Draft to Submit Transition)
    " =====================================================================
    IF update-row IS NOT INITIAL.
      LOOP AT update-row INTO DATA(ls_row_update).
        " Critical: Check if the UI *actually changed* the status to 'SUBM' during this update
        IF ls_row_update-%control-Statuscode = if_abap_behv=>mk-on AND ls_row_update-Statuscode = '02'.
          APPEND ls_row_update-RequestId TO lt_submitted_requests.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " =====================================================================
    " 3. HANDLE DMS ATTACHMENT UPLOAD TRIGGER (For Submitted Requests)
    " =====================================================================
    " If any requests were officially submitted, we gather ALL their pending attachments
    IF lt_submitted_requests IS NOT INITIAL.

      READ ENTITIES OF zrefx_i_row_request IN LOCAL MODE
        ENTITY Row BY \_RequestAttachments
        FIELDS ( RequestId AttachmentId Filename Mimetype Content )
        WITH VALUE #( FOR req IN lt_submitted_requests ( RequestId = req ) )
        RESULT DATA(lt_attachments_to_upload).

      LOOP AT lt_attachments_to_upload INTO DATA(ls_att).
        " Only trigger upload if there is physical file content in HANA
        IF ls_att-Content IS NOT INITIAL.
          APPEND VALUE #( requestid    = ls_att-RequestId
                          attachmentid = ls_att-AttachmentId
                          content      = ls_att-Content
                          filename     = ls_att-Filename
                          mimetype     = ls_att-Mimetype
                        ) TO lt_dms_create.
        ENDIF.
      ENDLOOP.

      IF lt_dms_create IS NOT INITIAL.
        TRY.
            lo_dms_op = NEW zcl_refx_bgpf_row_dms_up( ).
            lo_dms_op->set_context_data( it_context = lt_dms_create ).
            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'ROWDMSAttachUpload' )->set_operation( lo_dms_op )->save_for_execution( ).
          CATCH cx_bgmc ##NO_HANDLER.
            " Handle queue registration failure
        ENDTRY.
      ENDIF.

      " =====================================================================
      " 4. HANDLE SBPA WORKFLOW TRIGGER (For Submitted Requests)
      " =====================================================================
      " Read the full ROW Land records that were just submitted
      READ ENTITIES OF zrefx_i_row_request IN LOCAL MODE
        ENTITY Row ALL FIELDS
        WITH VALUE #( FOR req IN lt_submitted_requests ( RequestId = req ) )
        RESULT DATA(lt_full_requests).

      LOOP AT lt_full_requests INTO DATA(ls_full_req).
        TRY.
            lo_sbpa_op = NEW zcl_refx_bgpf_row_sbpa( ).

            " Get the current user's formatted name
            DATA lv_user_name TYPE zrefx_i_row_request-Currentprocessoruser.
            TRY.
                lv_user_name = cl_abap_context_info=>get_user_formatted_name( ).
              CATCH cx_abap_context_info_error ##NO_HANDLER.
            ENDTRY.

            " Set context for the workflow
            lo_sbpa_op->set_context_data(
              requestid   =  ls_full_req-RequestId
              SubmittedBy  = lv_user_name
            ).

            " Queue the operation in bgPF
            lo_process = cl_bgmc_process_factory=>get_default( )->create( ).
            lo_process->set_name( 'CallROWSBPA' )->set_operation( lo_sbpa_op )->save_for_execution( ).

          CATCH cx_bgmc INTO lx_bgmc ##NO_HANDLER.
        ENDTRY.

      ENDLOOP.

    ENDIF.

    " =====================================================================
    " 5. HANDLE DMS ATTACHMENT UPLOAD TRIGGER (For Direct API/UI Additions)
    " =====================================================================
    IF create-attachments IS NOT INITIAL.

      " 1. Read the parent status to ensure we don't upload Draft files
      DATA lt_parent_keys TYPE TABLE FOR READ IMPORT zrefx_i_row_request.
      LOOP AT create-attachments ASSIGNING FIELD-SYMBOL(<ls_att_keys>).
        APPEND VALUE #( RequestId = <ls_att_keys>-RequestId ) TO lt_parent_keys.
      ENDLOOP.

      SORT lt_parent_keys BY RequestId.
      DELETE ADJACENT DUPLICATES FROM lt_parent_keys COMPARING RequestId.

      READ ENTITIES OF zrefx_i_row_request IN LOCAL MODE
        ENTITY Row FIELDS ( Statuscode )
        WITH lt_parent_keys RESULT DATA(lt_parents).

      DATA lt_dms_create_api TYPE zcl_refx_bgpf_row_dms_up=>tt_context.

      LOOP AT create-attachments ASSIGNING FIELD-SYMBOL(<lfs_attachment>).
        " Skip if there's no content to upload
        IF <lfs_attachment>-Content IS INITIAL.
          CONTINUE.
        ENDIF.

        " === GUARD 1: DOUBLE TRIGGER PREVENTION ===
        " If this request was JUST submitted in this transaction,
        " the lt_submitted_requests block above already queued this file.
        IF line_exists( lt_submitted_requests[ table_line = <lfs_attachment>-RequestId ] ).
          CONTINUE.
        ENDIF.

        " === GUARD 2: DRAFT PREVENTION ===
        " If the parent is still a Draft, do not upload yet.
        READ TABLE lt_parents INTO DATA(ls_parent) WITH KEY entity COMPONENTS RequestId = <lfs_attachment>-RequestId.
        IF sy-subrc = 0 AND ( ls_parent-Statuscode = '02' OR ls_parent-Statuscode IS INITIAL ).
          CONTINUE.
        ENDIF.

        APPEND VALUE #(
          requestid    = <lfs_attachment>-RequestId
          attachmentid = <lfs_attachment>-AttachmentId
          content      = <lfs_attachment>-Content
          filename     = <lfs_attachment>-Filename
          mimetype     = <lfs_attachment>-Mimetype
        ) TO lt_dms_create_api.
      ENDLOOP.

      " Only schedule BgPF if we have valid files to process
      IF lt_dms_create_api IS NOT INITIAL.
        TRY.
            DATA(lo_dms_op_api) = NEW zcl_refx_bgpf_row_dms_up( ).
            lo_dms_op_api->set_context_data( it_context = lt_dms_create_api ).
            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'ROWDMSAttachAPIUpload' )->set_operation( lo_dms_op_api )->save_for_execution( ).
          CATCH cx_bgmc INTO DATA(lx_bgmc_api) ##NO_HANDLER.
        ENDTRY.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lhc_ZREFX_I_ROW_REQUEST DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrefx_i_row_request RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zrefx_i_row_request RESULT result.

ENDCLASS.

CLASS lhc_ZREFX_I_ROW_REQUEST IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
