CLASS lhc_workflowinstance DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS updateParentStatus FOR DETERMINE ON MODIFY
       keys FOR WorkflowInstance~updateParentStatus.

ENDCLASS.

CLASS lhc_workflowinstance IMPLEMENTATION.

  METHOD updateParentStatus.

    " 1. Read the newly created Workflow Info records from the RAP Buffer
    READ ENTITIES OF zrefx_i_gl_request IN LOCAL MODE
      ENTITY WorkflowInstance
      FIELDS ( RequestId CurrentStatus DecisionOutcome ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_wf_logs).

    DATA lt_parent_update TYPE TABLE FOR UPDATE zrefx_i_gl_request.

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
      MODIFY ENTITIES OF zrefx_i_gl_request IN LOCAL MODE
        ENTITY GovtLand
        UPDATE FIELDS ( Statuscode ) WITH lt_parent_update.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_reqattachment DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR ReqAttachment RESULT result.
    METHODS updateDmsId FOR MODIFY
       keys FOR ACTION ReqAttachment~updateDmsId RESULT result.
    METHODS download FOR MODIFY
       keys FOR ACTION ReqAttachment~download RESULT result.

ENDCLASS.

CLASS lhc_reqattachment IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateDmsId.

    DATA lv_empty_content TYPE xstring.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      " LOCAL MODE bypasses the UI lock to update Dmsid and wipe the HANA binary
      MODIFY ENTITIES OF zrefx_i_gl_request IN LOCAL MODE
        ENTITY ReqAttachment
        UPDATE FIELDS ( Dmsid Content )
        WITH VALUE #( ( RequestId         = <ls_key>-RequestId
                        AttachmentId      = <ls_key>-AttachmentId
                        Dmsid             = <ls_key>-%param-documentid
                        Content = lv_empty_content ) ).
    ENDLOOP.

    READ ENTITIES OF zrefx_i_gl_request IN LOCAL MODE
      ENTITY ReqAttachment ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_attachments).

    result = VALUE #( FOR att IN lt_attachments ( %tky = att-%tky %param = att ) ).

  ENDMETHOD.

  METHOD download.

    " Initialize the standard BTP CMIS Client
    DATA(lo_cmis_client) = cl_cmis_client_factory2=>get_instance( ).

    DATA: lv_repo_id    TYPE string,
          lv_documentid TYPE string.

    " Fetch the Repository ID from your newly built Config Table
    SELECT SINGLE config_value
      FROM zrefx_btp_config
      WHERE object_id = 'repository_id'
      INTO @lv_repo_id.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).

      lv_documentid = <ls_key>-%param-documentid.

      " Skip if no document ID was provided by the UI5 payload
      IF lv_documentid IS INITIAL.
        CONTINUE.
      ENDIF.

      TRY.
          " 1. Attempt the download stream from BTP DMS
          CALL METHOD lo_cmis_client->get_content_stream
            EXPORTING
              iv_repository_id = lv_repo_id
              iv_object_id     = lv_documentid
            IMPORTING
              es_content       = DATA(lv_content).

          " 2. Pass the xstring (binary stream) back to the UI5 front-end
          APPEND VALUE #(
           %cid   = <ls_key>-%cid
           %param = VALUE #( content = lv_content-stream )
           ) TO result.

          " --- ERROR HANDLING ---
        CATCH cx_cmis_object_not_found.
          " Document might have been deleted directly in BTP
          APPEND VALUE #( %cid = <ls_key>-%cid
                          %fail-cause = if_abap_behv=>cause-not_found ) TO failed-reqattachment.

          APPEND VALUE #( %cid = <ls_key>-%cid
                          %msg = new_message_with_text(
                                   text     = 'Document not found or already deleted in DMS.'
                                   severity = if_abap_behv_message=>severity-error )
                        ) TO reported-reqattachment.

        CATCH cx_cmis_root INTO DATA(lx_cmis).
          " Network timeout or configuration failure
          APPEND VALUE #( %cid = <ls_key>-%cid
                          %fail-cause = if_abap_behv=>cause-not_found ) TO failed-reqattachment.

          APPEND VALUE #( %cid = <ls_key>-%cid
                          %msg = new_message_with_text(
                                   text     = 'Failed to download document from DMS.'
                                   severity = if_abap_behv_message=>severity-error )
                        ) TO reported-reqattachment.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZREFX_I_GL_REQUEST DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR GovtLand RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR GovtLand RESULT result.

ENDCLASS.

CLASS lhc_ZREFX_I_GL_REQUEST IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZREFX_I_GL_REQUEST DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZREFX_I_GL_REQUEST IMPLEMENTATION.

  METHOD adjust_numbers.

    " =====================================================================
    " 1. ROOT: Government Land Request
    " =====================================================================
    DATA lv_number_raw TYPE cl_numberrange_runtime=>nr_number. "value from number range

    LOOP AT mapped-govtland ASSIGNING FIELD-SYMBOL(<lfs_gl>).

      " Always check if the Request ID is already assigned
      IF <lfs_gl>-RequestId IS INITIAL.

        TRY.
            "-------------------------------------------------------------------------------*
            " Get Next number using Number range Object for Govt. Land Process
            "-------------------------------------------------------------------------------*
            cl_numberrange_runtime=>number_get(
              EXPORTING
                nr_range_nr       = '01'
                object            = 'ZREFX_GLNR'
*                quantity          = 1
              IMPORTING
                number            = lv_number_raw
            ).
          CATCH cx_number_ranges INTO DATA(lx_error).  "##NO_HANDLER.
            " Fail fast - if NR fails, the app cannot survive
            RAISE SHORTDUMP lx_error.
        ENDTRY.

        <lfs_gl>-RequestId = |{ CONV i( lv_number_raw ) }|.
        DATA(current_date) = cl_abap_context_info=>get_system_date( ).
        DATA(current_year) = current_date(4).

        <lfs_gl>-RequestId  =  |{ 'GL' }{  current_year }{ <lfs_gl>-RequestId }|.
        CONDENSE <lfs_gl>-RequestId  NO-GAPS.

      ENDIF.

    ENDLOOP.

    " =====================================================================
    " 2. CHILD: Request Attachments
    " =====================================================================
    LOOP AT mapped-reqattachment ASSIGNING FIELD-SYMBOL(<lfs_ratt>).

      IF <lfs_ratt>-AttachmentId IS INITIAL.

        TRY.
            DATA(lv_attachmentid) = cl_system_uuid=>create_uuid_c32_static( ).
          CATCH cx_uuid_error.
            " Handle exception: Add message to reported or skip
            CONTINUE.
        ENDTRY.

        DATA(lv_RequestId) = <lfs_ratt>-%tmp-RequestId.

        <lfs_ratt>-RequestId  = lv_RequestId.
        <lfs_ratt>-AttachmentId = lv_attachmentid.

      ENDIF.

    ENDLOOP.

    " =====================================================================
    " 3. CHILD: Workflow Instance
    " =====================================================================
    LOOP AT mapped-workflowinstance ASSIGNING FIELD-SYMBOL(<ls_wf>).

      IF <ls_wf>-LogUuid IS INITIAL.

        TRY.
            <ls_wf>-LogUuid = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error.
        ENDTRY.

        <ls_wf>-RequestId = <ls_wf>-%tmp-RequestId.

      ENDIF.

    ENDLOOP.

*    " =====================================================================
*    " 2. CHILD: Clarification
*    " =====================================================================
*    LOOP AT mapped-clarification ASSIGNING FIELD-SYMBOL(<ls_clar>).
*      IF <ls_clar>-Id IS INITIAL.
*        TRY.
*            <ls_clar>-Id = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error.
*            RAISE SHORTDUMP TYPE cx_uuid_error.
*        ENDTRY.
*      ENDIF.
*    ENDLOOP.

*    " =====================================================================
*    " 3. CHILD: Land Allocation
*    " =====================================================================
*    LOOP AT mapped-landallocation ASSIGNING FIELD-SYMBOL(<ls_alloc>).
*      IF <ls_alloc>-LandNumber IS INITIAL.
*        TRY.
*            <ls_alloc>-LandNumber = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error. RAISE SHORTDUMP TYPE cx_uuid_error.
*        ENDTRY.
*      ENDIF.
*    ENDLOOP.

*    " =====================================================================
*    " 4. CHILD: Proposal
*    " =====================================================================
*    LOOP AT mapped-proposal ASSIGNING FIELD-SYMBOL(<ls_prop>).
*      IF <ls_prop>-Id IS INITIAL.
*        TRY.
*            <ls_prop>-Id = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error.
*            RAISE SHORTDUMP TYPE cx_uuid_error.
*        ENDTRY.
*      ENDIF.
*    ENDLOOP.

*    " =====================================================================
*    " 5. CHILD: Proposed Land
*    " =====================================================================
*    LOOP AT mapped-proposedland ASSIGNING FIELD-SYMBOL(<ls_pland>).
*      IF <ls_pland>-Id IS INITIAL.
*        TRY.
*            <ls_pland>-Id = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error.
*            RAISE SHORTDUMP TYPE cx_uuid_error.
*        ENDTRY.
*      ENDIF.
*    ENDLOOP.

*    " =====================================================================
*    " 6. CHILD: Site Visit
*    " =====================================================================
*    LOOP AT mapped-sitevisit ASSIGNING FIELD-SYMBOL(<ls_sv>).
*      IF <ls_sv>-id IS INITIAL.
*        TRY.
*            <ls_sv>-id = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error.
*            RAISE SHORTDUMP TYPE cx_uuid_error.
*        ENDTRY.
*      ENDIF.
*    ENDLOOP.

*    " =====================================================================
*    " 7. CHILD: Site Visit Attachments
*    " =====================================================================
*    LOOP AT mapped-sitevisitattachment ASSIGNING FIELD-SYMBOL(<ls_svatt>).
*      IF <ls_svatt>-Dmsid IS INITIAL.
*        TRY.
*            <ls_svatt>-Dmsid = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error.
*            RAISE SHORTDUMP TYPE cx_uuid_error.
*        ENDTRY.
*      ENDIF.
*    ENDLOOP.

*    " =====================================================================
*    " 8. CHILD: Site Visit Nom
*    " =====================================================================
*    LOOP AT mapped-sitevisitnom ASSIGNING FIELD-SYMBOL(<ls_svnom>).
*      IF <ls_svnom>-id IS INITIAL.
*        TRY.
*            <ls_svnom>-id = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error.
*            RAISE SHORTDUMP TYPE cx_uuid_error.
*        ENDTRY.
*      ENDIF.
*    ENDLOOP.

  ENDMETHOD.

  METHOD save_modified.

    " =====================================================================
    " VARIABLE DECLARATIONS
    " =====================================================================
    " Variables for DMS Background Process
    DATA: lo_dms_op     TYPE REF TO zcl_refx_bgpf_gl_dms_up,
          lt_dms_create TYPE zcl_refx_bgpf_gl_dms_up=>tt_context.

    " Variables for SBPA Background Process
    DATA: lo_sbpa_op TYPE REF TO zcl_refx_bgpf_gl_sbpa,
          lo_process TYPE REF TO if_bgmc_process_single_op,
          lx_bgmc    TYPE REF TO cx_bgmc.

    " Keep track of which Govt Land requests were officially 'Submitted' in this transaction
    DATA lt_submitted_requests TYPE TABLE OF zrefx_gl-request_id.

    " =====================================================================
    " 1. TRACK SUBMISSIONS FROM 'CREATE'
    " =====================================================================
    IF create-govtland IS NOT INITIAL.
      LOOP AT create-govtland INTO DATA(ls_gl_create).
        " If the UI immediately passed 'SUBM' on creation
        IF ls_gl_create-Statuscode = 'SUBMITTED'.
          APPEND ls_gl_create-RequestId TO lt_submitted_requests.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " =====================================================================
    " 2. TRACK SUBMISSIONS FROM 'UPDATE' (Draft to Submit Transition)
    " =====================================================================
    IF update-govtland IS NOT INITIAL.
      LOOP AT update-govtland INTO DATA(ls_gl_update).
        " Critical: Check if the UI *actually changed* the status to 'SUBM' during this update
        IF ls_gl_update-%control-Statuscode = if_abap_behv=>mk-on AND ls_gl_update-Statuscode = 'SUBMITTED'.
          APPEND ls_gl_update-RequestId TO lt_submitted_requests.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " =====================================================================
    " 3. HANDLE DMS ATTACHMENT UPLOAD TRIGGER (For Submitted Requests)
    " =====================================================================
    " If any requests were officially submitted, we gather ALL their pending attachments
    IF lt_submitted_requests IS NOT INITIAL.

      READ ENTITIES OF zrefx_i_gl_request IN LOCAL MODE
        ENTITY GovtLand BY \_RequestAttachments
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
            lo_dms_op = NEW zcl_refx_bgpf_gl_dms_up( ).
            lo_dms_op->set_context_data( it_context = lt_dms_create ).
            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'GLDMSAttachUpload' )->set_operation( lo_dms_op )->save_for_execution( ).
          CATCH cx_bgmc ##NO_HANDLER.
            " Handle queue registration failure
        ENDTRY.
      ENDIF.

      " =====================================================================
      " 4. HANDLE SBPA WORKFLOW TRIGGER (For Submitted Requests)
      " =====================================================================
      " Read the full Govt Land records that were just submitted
      READ ENTITIES OF zrefx_i_gl_request IN LOCAL MODE
        ENTITY GovtLand ALL FIELDS
        WITH VALUE #( FOR req IN lt_submitted_requests ( RequestId = req ) )
        RESULT DATA(lt_full_requests).

      LOOP AT lt_full_requests INTO DATA(ls_full_req).
        TRY.
            lo_sbpa_op = NEW zcl_refx_bgpf_gl_sbpa( ).

            " Get the current user's formatted name
            DATA lv_user_name TYPE string.
            TRY.
                lv_user_name = cl_abap_context_info=>get_user_formatted_name( ).
              CATCH cx_abap_context_info_error ##NO_HANDLER.
            ENDTRY.

            " Set context for the workflow
            lo_sbpa_op->set_context_data(
              requestid   = CONV string( ls_full_req-RequestId )
              submittedby = lv_user_name
            ).

            " Queue the operation in bgPF
            lo_process = cl_bgmc_process_factory=>get_default( )->create( ).
            lo_process->set_name( 'CallGLSBPA' )->set_operation( lo_sbpa_op )->save_for_execution( ).

          CATCH cx_bgmc INTO lx_bgmc ##NO_HANDLER.
        ENDTRY.

      ENDLOOP.

    ENDIF.

    " =====================================================================
    " 5. HANDLE DMS ATTACHMENT UPLOAD TRIGGER (For Direct API/UI Additions)
    " =====================================================================
    IF create-reqattachment IS NOT INITIAL.

      " 1. Read the parent status to ensure we don't upload Draft files
      DATA lt_parent_keys TYPE TABLE FOR READ IMPORT zrefx_i_gl_request.
      LOOP AT create-reqattachment ASSIGNING FIELD-SYMBOL(<ls_att_keys>).
        APPEND VALUE #( RequestId = <ls_att_keys>-RequestId ) TO lt_parent_keys.
      ENDLOOP.

      SORT lt_parent_keys BY RequestId.
      DELETE ADJACENT DUPLICATES FROM lt_parent_keys COMPARING RequestId.

      READ ENTITIES OF zrefx_i_gl_request IN LOCAL MODE
        ENTITY GovtLand FIELDS ( Statuscode )
        WITH lt_parent_keys RESULT DATA(lt_parents).

      DATA lt_dms_create_api TYPE zcl_refx_bgpf_gl_dms_up=>tt_context.

      LOOP AT create-reqattachment ASSIGNING FIELD-SYMBOL(<lfs_attachment>).
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
        IF sy-subrc = 0 AND ( ls_parent-Statuscode = 'DRAFT' OR ls_parent-Statuscode IS INITIAL ).
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
            DATA(lo_dms_op_api) = NEW zcl_refx_bgpf_gl_dms_up( ).
            lo_dms_op_api->set_context_data( it_context = lt_dms_create_api ).
            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'GLDMSAttachAPIUpload' )->set_operation( lo_dms_op_api )->save_for_execution( ).
          CATCH cx_bgmc INTO DATA(lx_bgmc_api) ##NO_HANDLER.
        ENDTRY.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
