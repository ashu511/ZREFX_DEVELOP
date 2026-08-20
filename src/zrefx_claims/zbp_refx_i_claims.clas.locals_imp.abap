CLASS lhc_workflowinfo DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS updateParentStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR WorkflowInfo~updateParentStatus.

ENDCLASS.

CLASS lhc_workflowinfo IMPLEMENTATION.

  METHOD updateParentStatus.
*    " 1. Read the newly created Workflow Info records from the RAP Buffer
*    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY WorkflowInfo
*      FIELDS ( ClaimId CurrentStatus ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_wf_logs).
*
*    DATA lt_parent_update TYPE TABLE FOR UPDATE zrefx_i_claims.
*
*    " 2. Evaluate the SBPA payload and determine the new parent status
*    LOOP AT lt_wf_logs INTO DATA(ls_wf_log).
*
*      " Default status when a workflow log is created
*      DATA(lv_new_parent_status) = 'Submitted'.
*
*      " Check if SBPA sent a final state
*      IF ls_wf_log-CurrentStatus = 'REJECTED' OR ls_wf_log-CurrentStatus = 'REJECT'.
*        lv_new_parent_status = 'Rejected'.
*      ELSEIF ls_wf_log-CurrentStatus = 'COMPLETED'.
*        lv_new_parent_status = 'Completed'.
*      ENDIF.
*
*      " Queue the parent for an update
*      APPEND VALUE #( %tky   = VALUE #( ClaimId = ls_wf_log-ClaimId )
*                      Status = lv_new_parent_status ) TO lt_parent_update.
*    ENDLOOP.
*
*    " 3. Remove duplicates (in case SBPA posted multiple logs simultaneously)
*    SORT lt_parent_update BY %tky-ClaimId.
*    DELETE ADJACENT DUPLICATES FROM lt_parent_update COMPARING %tky-ClaimId.
*
*    " 4. Update the Parent Complaint using LOCAL MODE (bypasses read-only locks)
*    IF lt_parent_update IS NOT INITIAL.
*      MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
*        ENTITY claims
*        UPDATE FIELDS ( Status ) WITH lt_parent_update.
*    ENDIF.


    " 1. Read the newly created Workflow Info records from the RAP Buffer
    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
      ENTITY WorkflowInfo
      FIELDS ( ClaimId CurrentStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_wf_logs).

    DATA lt_parent_update TYPE TABLE FOR UPDATE zrefx_i_claims.

    " 2. Evaluate the SBPA payload and determine the new parent status
    LOOP AT lt_wf_logs INTO DATA(ls_wf_log).

      " Default status when a workflow log is created
* DATA(lv_new_parent_status) = '02'.

      " Check if SBPA sent a final state
      IF ls_wf_log-CurrentStatus = 'REJECTED' OR ls_wf_log-CurrentStatus = 'REJECT'.
        DATA(lv_new_parent_status) = '04'.
      ELSEIF ls_wf_log-CurrentStatus = 'COMPLETED'.
        lv_new_parent_status = '03'.
      ENDIF.
      IF lv_new_parent_status IS NOT INITIAL.
        " Queue the parent for an update
        APPEND VALUE #( %tky   = VALUE #( ClaimId = ls_wf_log-ClaimId )
                        Status = lv_new_parent_status ) TO lt_parent_update.
      ENDIF.
    ENDLOOP.

    IF lt_parent_update IS NOT INITIAL.
      " 3. Remove duplicates (in case SBPA posted multiple logs simultaneously)
      SORT lt_parent_update BY %tky-Claimid.
      DELETE ADJACENT DUPLICATES FROM lt_parent_update COMPARING %tky-ClaimId.
    ENDIF.
    " 4. Update the Parent Complaint using LOCAL MODE (bypasses read-only locks)
    IF lt_parent_update IS NOT INITIAL.
      MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
        ENTITY claims
        UPDATE FIELDS ( Status ) WITH lt_parent_update.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_attachments DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR Attachments RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR attachments RESULT result.

    METHODS download FOR MODIFY
      IMPORTING keys FOR ACTION attachments~download RESULT result.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR ACTION attachments~delete RESULT result.
    METHODS updatedmsid FOR MODIFY
      IMPORTING keys FOR ACTION attachments~updatedmsid RESULT result.

ENDCLASS.

CLASS lhc_attachments IMPLEMENTATION.

*  METHOD get_instance_features.

*    "Read the DMS ID to check if the record was already processed by the system
*    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY Attachments
*      FIELDS ( Dmsid ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_attachments).
*
*    result = VALUE #( FOR attachment IN lt_attachments
*                        ( %tky = attachment-%tky
*                          %features-%update = COND #(
*                          " CONDITION 1: It is a brand new record (No ID yet)
*                          " We must allow update so the user can fill initial fields
*                          WHEN attachment-Dmsid IS INITIAL
*                          THEN if_abap_behv=>fc-o-enabled
*
*                          " CONDITION 2: The DMS ID is present.
*                          " This means the background process already ran. Lock it.
*                          ELSE if_abap_behv=>fc-o-disabled )
*                        )
*                    ).

*ENDMETHOD.

  METHOD get_global_authorizations.
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



*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
*
*      DATA : lv_documentid TYPE string,
*             lv_repo_id    TYPE string.
*
*      lv_documentid = <ls_key>-%param-documentid.
*
** Get the CMIS Client
*      DATA(lo_cmis_client) = cl_cmis_client_factory2=>get_instance( ).
*
** Download the object                                                                                     *
*      SELECT SINGLE config_value
*        FROM zrefx_btp_config
*        WHERE object_id   = 'repository_id'
*        INTO @lv_repo_id.
*
*      CALL METHOD lo_cmis_client->get_content_stream
*        EXPORTING
*          iv_repository_id = lv_repo_id
*          iv_object_id     = lv_documentid
*        IMPORTING
*          es_content       = DATA(lv_content).
*
** Pass value back to the front-end as response
*      APPEND VALUE #(
*       %cid   = <ls_key>-%cid
*       %param = VALUE #( content = lv_content-stream )
*       ) TO result.
*
*    ENDLOOP.
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

      DATA(lv_claimid) = <ls_key>-%param-claimid.
      DATA(lv_attachmentid) = <ls_key>-%param-attachmentid.

      " 1. Read the DMS ID from the database using the provided keys
      READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
        ENTITY Attachments
        FIELDS ( Dmsid )
        WITH VALUE #( ( ClaimId = lv_claimid AttachmentId = lv_attachmentid ) )
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
          DATA(lv_folder_path) = |/{ lv_claimid }|.
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
      MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
        ENTITY Attachments
          DELETE FROM VALUE #( ( ClaimId = lv_claimid AttachmentId = lv_attachmentid ) ).

    ENDLOOP.

    " If you defined result [1] $self for delete, map it here.
    " If you don't need a result, change the BDEF to just `static action delete parameter...;`



  ENDMETHOD.

  METHOD updateDmsId.
    DATA lv_empty_content TYPE xstring.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      " This LOCAL MODE bypasses the UI lock!
      MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
        ENTITY Attachments
        UPDATE FIELDS ( Dmsid Content )
        WITH VALUE #( ( ClaimId  = <ls_key>-ClaimId
                        AttachmentId = <ls_key>-AttachmentId
                        Dmsid        = <ls_key>-%param-documentid
                        Content      = lv_empty_content ) ).
    ENDLOOP.

    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
      ENTITY Attachments ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_attachments).

    result = VALUE #( FOR att IN lt_attachments ( %tky = att-%tky %param = att ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zrefx_i_claims DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zrefx_i_claims IMPLEMENTATION.
  METHOD save_modified.
    " Variables to Trigger the SBPA for created complaints
    DATA: lo_operation TYPE REF TO zcl_refx_bgpf_claims_sbpa,
          lo_process   TYPE REF TO if_bgmc_process_single_op,
          lx_bgmc      TYPE REF TO cx_bgmc.

    " Variables for DMS Background Process
    DATA: lo_dms_op     TYPE REF TO zcl_refx_bgpf_claim_dms_up,
          lt_dms_create TYPE zcl_refx_bgpf_claim_dms_up=>tt_context,
          lo_dms_del    TYPE REF TO zcl_refx_bgpf_dms_att_delete, "zcl_refx_bgpf_comp_dms_del,
          lt_dms_delete TYPE zcl_refx_bgpf_dms_att_delete=>tt_context.

    " Keep track of which complaints were officially 'Submitted' in this transaction
    DATA lt_submitted_claims TYPE TABLE OF zrefx_claims-claim_id.

    " For Create Scenario
    IF create-claims IS NOT INITIAL.

      LOOP AT create-claims INTO DATA(ls_claims).

        " If the UI immediately passed '02' on creation
        IF ls_claims-Status = '02'.

          APPEND ls_claims-Claimid TO lt_submitted_claims.

          TRY.
              " 1. Create an operation instance
              lo_operation = NEW zcl_refx_bgpf_claims_sbpa( ).

              " 2. Set the context data - this will be passed to the SBPA workflow
              " Get the current user's technical name and formatted name for the 'CreatedBy' and 'SubmittedBy' fields in the workflow context
              TRY.
                  DATA(lv_user_name) = cl_abap_context_info=>get_user_formatted_name( ).
                CATCH cx_abap_context_info_error ##NO_HANDLER.
                  "handle exception
              ENDTRY.

              lo_operation->set_context_data(
                                            claimid      = ls_claims-Claimid
                                            claimtype     = ls_claims-Claimtype
                                            claimcategory = ls_claims-Claimcategory
                                            sourcechannel = ls_claims-Sourcechannel
                                            claimsubject  = ls_claims-Claimsubject
                                            claimamount   = ls_claims-Claimamount
                                            description   = ls_claims-Detaileddescription
                                            status        = ls_claims-Status
*                                            CreatedBy     = lv_user_name
                                            submittedby   = CONV string( ls_claims-requestoremail ) "lv_user_name
                                            landid        = ls_claims-Landid
                                            titledeed     = ls_claims-Titledeedno
                                            vendoremail   = ls_claims-Contactemail
                                            vendorname_en = ls_claims-Vendorname
                                            vendorname_ar = ls_claims-Vendorname
                                            submittedon   = ls_claims-Createddate
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
    IF update-claims IS NOT INITIAL.
      LOOP AT update-claims INTO DATA(ls_update).
        " Critical: Check if the UI *actually changed* the status to '02' during this update
        IF ls_update-%control-Status = if_abap_behv=>mk-on AND ls_update-Status = '02'.

          APPEND ls_update-Claimid TO lt_submitted_claims.

          " We must read the full active record from the DB/Buffer to send to SBPA
          READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
            ENTITY claims ALL FIELDS WITH VALUE #( ( Claimid = ls_update-Claimid ) )
            RESULT DATA(lt_full_claim).

          IF lt_full_claim IS NOT INITIAL.
            DATA(ls_full) = lt_full_claim[ 1 ].
            TRY.
                lo_operation = NEW zcl_refx_bgpf_claims_sbpa( ).
                lv_user_name = cl_abap_context_info=>get_user_formatted_name( ).
                lo_operation->set_context_data(
                                             claimid      = ls_full-Claimid
                                            claimtype     = ls_full-Claimtype
                                            claimcategory = ls_full-Claimcategory
                                            sourcechannel = ls_full-Sourcechannel
                                            claimsubject  = ls_full-Claimsubject
                                            claimamount   = ls_full-Claimamount
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
    IF lt_submitted_claims IS NOT INITIAL.

      READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
        ENTITY claims BY \_Attachments
        FIELDS ( ClaimId AttachmentId Content )
        WITH VALUE #( FOR clmp IN lt_submitted_claims ( Claimid = clmp ) )
        RESULT DATA(lt_attachments_to_upload).

      LOOP AT lt_attachments_to_upload INTO DATA(ls_att).
        " Only trigger upload if there is physical file content in HANA
        " Only trigger upload if there is physical file content in HANA
        IF ls_att-Content IS NOT INITIAL.
          APPEND VALUE #( claimid  = ls_att-claimId
                          attachmentid = ls_att-AttachmentId
                          content      = ls_att-Content
                          filename     = ls_att-Filename
                           mimetype    = ls_att-Mimetype
                         ) TO lt_dms_create.
        ENDIF.
      ENDLOOP.

      IF lt_dms_create IS NOT INITIAL.
        TRY.
            lo_dms_op = NEW zcl_refx_bgpf_claim_dms_up( ).

            lo_dms_op->set_context_data( it_context = lt_dms_create ).
            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentUpload' )->set_operation( lo_dms_op )->save_for_execution( ).
          CATCH cx_root ##NO_HANDLER.
        ENDTRY.
      ENDIF.

    ENDIF.

    IF create-attachments IS NOT INITIAL.

      " 1. Read the parent status to ensure we don't upload Draft files
      DATA lt_parent_keys TYPE TABLE FOR READ IMPORT zrefx_i_claims.
      LOOP AT create-attachments ASSIGNING FIELD-SYMBOL(<ls_att_keys>).
        APPEND VALUE #( ClaimId = <ls_att_keys>-ClaimId ) TO lt_parent_keys.
      ENDLOOP.

      SORT lt_parent_keys BY Claimid.
      DELETE ADJACENT DUPLICATES FROM lt_parent_keys COMPARING Claimid.

      READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
        ENTITY claims FIELDS ( Status )
        WITH lt_parent_keys RESULT DATA(lt_parents).

      DATA lt_dms_create_api TYPE zcl_refx_bgpf_claim_dms_up=>tt_context.

      LOOP AT create-attachments ASSIGNING FIELD-SYMBOL(<lfs_attachment>).
        " Skip if there's no content to upload
        IF <lfs_attachment>-Content IS INITIAL.
          CONTINUE.
        ENDIF.

        " === GUARD 1: DOUBLE TRIGGER PREVENTION ===
        " If this complaint was JUST submitted in this transaction,
        " the lt_submitted_complaints block above already queued this file.
        IF line_exists( lt_submitted_claims[ table_line = <lfs_attachment>-ClaimId ] ).
          CONTINUE.
        ENDIF.

        " === GUARD 2: DRAFT PREVENTION ===
        " If the parent is still a Draft ('01' or blank), do not upload yet.
        READ TABLE lt_parents INTO DATA(ls_parent)
        WITH KEY entity COMPONENTS
        Claimid = <lfs_attachment>-ClaimId.
        IF sy-subrc = 0 AND ( ls_parent-Status = '01' OR ls_parent-Status IS INITIAL ).
          CONTINUE.
        ENDIF.

        APPEND VALUE #(
          claimid      = <lfs_attachment>-ClaimId
          attachmentid = <lfs_attachment>-AttachmentId
          content      = <lfs_attachment>-Content
          filename     = <lfs_attachment>-Filename
          mimetype     = <lfs_attachment>-Mimetype
        ) TO lt_dms_create_api.
      ENDLOOP.

      " Only schedule BgPF if we have valid files to process
      IF lt_dms_create_api IS NOT INITIAL.
        TRY.
            DATA(lo_dms_op_api) = NEW zcl_refx_bgpf_claim_dms_up( ).
            lo_dms_op_api->set_context_data( it_context = lt_dms_create_api ).
            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentAPIUpload' )->set_operation( lo_dms_op_api )->save_for_execution( ).
          CATCH cx_bgmc INTO DATA(lx_bgmc_api) ##NO_HANDLER.
        ENDTRY.
      ENDIF.
    ENDIF.

*    DATA lv_number_raw TYPE cl_numberrange_runtime=>nr_number. "value from number range
*
*    " Variables to Trigger the SBPA for created complaints
*    DATA: lo_operation TYPE REF TO zcl_refx_bgpf_claims_sbpa,
*          lo_process   TYPE REF TO if_bgmc_process_single_op,
*          lx_bgmc      TYPE REF TO cx_bgmc.
*
*    " Variables for DMS Background Process
*    DATA: lo_dms_op     TYPE REF TO zcl_refx_bgpf_claim_dms_up,
*          lt_dms_create TYPE zcl_refx_bgpf_claim_dms_up=>tt_context,
*          lo_dms_del    TYPE REF TO zcl_refx_bgpf_dms_att_delete,
*          lt_dms_delete TYPE zcl_refx_bgpf_dms_att_delete=>tt_context.
*
**-------------------------------------------------------------------------------*
**                      Create Claim and trigger SBPA Workflow
**-------------------------------------------------------------------------------*
*    LOOP AT create-claims ASSIGNING FIELD-SYMBOL(<fs_claims>). "REFERENCE INTO DATA(map).
*      TRY.
*          " 1. Create an operation instance
*          lo_operation = NEW zcl_refx_bgpf_claims_sbpa( ).
*
*          " 2. Set the context data - this will be passed to the SBPA workflow
*          DATA(lv_user_id) = cl_abap_context_info=>get_user_technical_name( ).
*          TRY.
*              DATA(lv_user_name) = cl_abap_context_info=>get_user_formatted_name( ).
*            CATCH cx_abap_context_info_error ##NO_HANDLER.
*              "handle exception
*          ENDTRY.
*
*          lo_operation->set_context_data(
*
**                                          claimid      = <fs_claims>-Claimid
**                                          claim_type   = <fs_claims>-Claimtype
**                                          claim_ref_no = <fs_claims>-Claimreferenceno
**                                          claim_amount = <fs_claims>-Claimamount
*                                            claimid       = <fs_claims>-Claimid
*                                            claimtype     = <fs_claims>-Claimtype
*                                            claimcategory = <fs_claims>-Claimcategory
*                                            sourcechannel = <fs_claims>-Sourcechannel
*                                            claimsubject  = <fs_claims>-Claimsubject
*                                            claimamount   = <fs_claims>-Claimamount
*                                            description   = <fs_claims>-Detaileddescription
*                                            status        = <fs_claims>-Status
*                                            CreatedBy     = lv_user_name
*                                            landid        = <fs_claims>-Landid
*                                            titledeed     = <fs_claims>-Titledeedno
*                                            vendoremail   = <fs_claims>-Contactemail
*                                            vendorname_en = <fs_claims>-Vendorname
*                                            vendorname_ar = <fs_claims>-Vendorname
**                                            submittedby  =   <fs_claims>-
*                                            createddate   = <fs_claims>-Createddate
*                                           ).
*
*          " 3. Get the bgPF process factory and create a process
*          lo_process = cl_bgmc_process_factory=>get_default( )->create( ).
*
*          " 4. Set a name for monitoring and inject the operation
*          lo_process->set_name( 'CallClaimsBPA' )->set_operation( lo_operation ).
*
*          " 5. Save for execution (the actual trigger happens after COMMIT)
*          lo_process->save_for_execution( ).
*
*        CATCH cx_bgmc INTO lx_bgmc.
*          " Handle registration errors here
*      ENDTRY.
*    ENDLOOP.
**-------------------------------------------------------------------------------*
**                              Create Attachment
**-------------------------------------------------------------------------------*
*    IF create-attachments IS NOT INITIAL.
*
*      LOOP AT create-attachments ASSIGNING FIELD-SYMBOL(<lfs_attachment>).
*
*        "Skip if there's no content to upload
*        IF <lfs_attachment>-content IS INITIAL.
*          CONTINUE.
*        ENDIF.
*
*        APPEND VALUE #(
*          claimid  = <lfs_attachment>-ClaimId
*          attachmentid = <lfs_attachment>-attachmentid
*          content      = <lfs_attachment>-content
*          filename     = <lfs_attachment>-filename
*          mimetype     = <lfs_attachment>-mimetype
*        ) TO lt_dms_create.
*
*      ENDLOOP.
*
*      "Only schedule BgPF if we actually have files to process
*      IF lt_dms_create IS NOT INITIAL.
*
*        TRY.
*
*            lo_dms_op = NEW zcl_refx_bgpf_claim_dms_up( ).
*
*            lo_dms_op->set_context_data( it_context = lt_dms_create ).
*
*            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentUpload' )->set_operation( lo_dms_op )->save_for_execution( ).
*
*          CATCH cx_bgmc INTO lx_bgmc.
*
*            " Handle queue registration failure
*
*        ENDTRY.
*
*      ENDIF.
*
*    ENDIF.
**-------------------------------------------------------------------------------*
**                              Delete Attachment
**-------------------------------------------------------------------------------*
*
*    IF delete-attachments IS NOT INITIAL.
*
*      LOOP AT delete-attachments ASSIGNING FIELD-SYMBOL(<lfs_delete>).
*
*        "Skip if there's no attachment or complaint id - both are required to identify the file to delete
*        IF <lfs_delete>-AttachmentId IS INITIAL AND <lfs_delete>-ClaimId IS INITIAL.
*          CONTINUE.
*        ENDIF.
*
*        APPEND VALUE #(
*          claimid  = <lfs_delete>-ClaimId
*          attachmentid = <lfs_delete>-attachmentid
*        ) TO lt_dms_delete.
*
*      ENDLOOP.
*
*      "Only schedule BgPF if we actually have files to process
*      IF lt_dms_delete IS NOT INITIAL.
*
*        " Fetch the dmsid from your Z-table before passing it to the background process
*        SELECT claim_id , attachment_id, dmsid
*          FROM zrefx_att_claims
*          FOR ALL ENTRIES IN @lt_dms_delete
*          WHERE claim_id = @lt_dms_delete-claimid
*            AND attachment_id = @lt_dms_delete-attachmentid
*          INTO TABLE @DATA(lt_dms_info).
*
*        " Update your context to include the dmsid
*        LOOP AT lt_dms_delete ASSIGNING FIELD-SYMBOL(<ls_del>).
*          READ TABLE lt_dms_info INTO DATA(ls_info)
*            WITH KEY claim_id = <ls_del>-claimid
*                     attachment_id = <ls_del>-attachmentid.
*          IF sy-subrc = 0.
*            <ls_del>-documentid = ls_info-dmsid.
*          ENDIF.
*        ENDLOOP.
*
*        TRY.
*
*            lo_dms_del = NEW zcl_refx_bgpf_dms_att_delete( ).
*
*            lo_dms_del->set_context_data( it_context = lt_dms_delete ).
*
*            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentDelete' )->set_operation( lo_dms_del )->save_for_execution( ).
*
*          CATCH cx_bgmc INTO lx_bgmc.
*
*            " Handle queue registration failure
*
*        ENDTRY.
*
*      ENDIF.
*
*    ENDIF.

  ENDMETHOD.

  METHOD adjust_numbers.
*-------------------------------------------------------------------------------*
* Get Next number using Number range Object for Claim Process
*-------------------------------------------------------------------------------*
    DATA lv_number_raw TYPE cl_numberrange_runtime=>nr_number. "value from number range

    " Variables to Trigger the SBPA for created complaints
    DATA: lo_operation TYPE REF TO zcl_refx_bgpf_claims_sbpa,
          lo_process   TYPE REF TO if_bgmc_process_single_op,
          lx_bgmc      TYPE REF TO cx_bgmc.

    LOOP AT mapped-claims ASSIGNING FIELD-SYMBOL(<fs_claims>). "REFERENCE INTO DATA(map).
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = '01'
              object            = 'ZREFX_CLNR'
*              quantity          = 1
            IMPORTING
              number            = lv_number_raw
          ).
        CATCH cx_number_ranges INTO DATA(lx_error)  ##NO_HANDLER.

      ENDTRY.
      <fs_claims>-Claimid = |{ CONV i( lv_number_raw ) }|.
      DATA(current_date) = cl_abap_context_info=>get_system_date( ).
      DATA(current_year) = current_date(4).
      <fs_claims>-Claimid =  |{ 'CLM' } {  current_year } { <fs_claims>-Claimid }|.
      CONDENSE <fs_claims>-Claimid NO-GAPS.
    ENDLOOP.
* Attachments
    LOOP AT mapped-attachments ASSIGNING FIELD-SYMBOL(<lfs_att>).
      TRY.
          DATA(lv_attachid) = cl_system_uuid=>create_uuid_c32_static( ).
        CATCH cx_uuid_error.
          " Handle exception: Add message to reported or skip
          CONTINUE.
      ENDTRY.

      DATA(lv_CLAIMId) = <lfs_att>-%tmp-ClaimId.

      <lfs_att>-ClaimId  = lv_CLAIMId.
      <lfs_att>-AttachmentId = lv_attachid.

    ENDLOOP.
* Workflow Information
    " Generate UUIDs for new Workflow Log lines
    LOOP AT mapped-workflowinfo ASSIGNING FIELD-SYMBOL(<lfs_wf>).
      TRY.
          <lfs_wf>-LogUuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          CONTINUE.
      ENDTRY.
      <lfs_wf>-ClaimId = <lfs_wf>-%tmp-ClaimId.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZREFX_I_CLAIMS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR claims RESULT result.
*    METHODS setstatusdraft FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR claims~setstatusdraft.
    METHODS setinitialdate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR claims~setinitialdate.
*    METHODS populateexternalvendor FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR claims~populateexternalvendor.
*    METHODS fetchvendordetails FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR claims~fetchvendordetails.
*    METHODS validate_confirminformation FOR VALIDATE ON SAVE
*      IMPORTING keys FOR claims~validate_confirminformation.
*    METHODS validatemandatoryfields FOR VALIDATE ON SAVE
*      IMPORTING keys FOR claims~validatemandatoryfields.

    METHODS UpdateDivision FOR MODIFY
      IMPORTING keys FOR ACTION claims~UpdateDivision RESULT result.
*    METHODS updateworkflowinfo FOR MODIFY
*      IMPORTING keys FOR ACTION claims~updateworkflowinfo RESULT result.
*    METHODS setstatussubmitted FOR MODIFY
*      IMPORTING keys FOR ACTION claims~setstatussubmitted RESULT result.
*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR claims RESULT result.

ENDCLASS.

CLASS lhc_ZREFX_I_CLAIMS IMPLEMENTATION.


  METHOD get_global_authorizations.
  ENDMETHOD.

*  METHOD setStatusDraft.
*    " Read the keys of the instances being created
*    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY claims
*      FIELDS ( Status ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_claim_Status).
*
*    " Filter out records that already have a date
*    DELETE lt_claim_Status WHERE Status IS NOT INITIAL.
*    CHECK lt_claim_Status IS NOT INITIAL.
*
*    " Update the entities with the current system date
*    MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY claims
*      UPDATE FIELDS ( Status )
*      WITH VALUE #( FOR status IN lt_claim_Status (
*          %tky      = status-%tky
*          Status =  'Draft'
*      ) ).
*
*  ENDMETHOD.

  METHOD setInitialDate.
    " Read the keys of the instances being created
    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
      ENTITY claims
      FIELDS ( Createddate ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_claim_date).

    " Filter out records that already have a date
    DELETE lt_claim_date WHERE Createddate IS NOT INITIAL.
    CHECK lt_claim_date IS NOT INITIAL.

    " Update the entities with the current system date
    MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
      ENTITY claims
*      UPDATE FIELDS ( Createddate Consentdate  )
      UPDATE FIELDS ( Createddate )
      WITH VALUE #( FOR travel IN lt_claim_date (
          %tky      = travel-%tky
          Createddate = cl_abap_context_info=>get_system_date( )
*          Consentdate = cl_abap_context_info=>get_system_date( )
      ) ).
  ENDMETHOD.

*  METHOD populateExternalVendor.
*    TYPES: BEGIN OF ty_range_line,
*             sign   TYPE c LENGTH 1,
*             option TYPE c LENGTH 2,
*             low    TYPE string,
*             high   TYPE string,
*           END OF ty_range_line,
*           tt_range_tab TYPE STANDARD TABLE OF ty_range_line WITH EMPTY KEY.
*
*    DATA lt_vendor_range TYPE tt_range_tab.
*
*    DATA: lv_email  TYPE string,
*          lt_update TYPE TABLE FOR UPDATE zrefx_i_claims.
*
*    " 1. Verify if user is actually external
*    TRY.
*        DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).
*        SELECT SINGLE \_WorkplaceAddress-DefaultEmailAddress
*            FROM I_BusinessUserBasic WITH PRIVILEGED ACCESS
*            WHERE UserID = @lv_technical_name
*            INTO @lv_email.
*      CATCH cx_abap_context_info_error.
*        RETURN.
*    ENDTRY.
*
*    IF lv_email CS '@se.com.sa'.
*      RETURN. " Exit if internal user
*    ENDIF.
*
*    " 2. Call your ECC OData Service API
*    TRY.
*
*        " Establish connection via BTP Destination 'refx_gw_ba'
*        DATA(lo_dest) = cl_http_destination_provider=>create_by_cloud_destination(
*          i_name      = 'refx_gw_ba' ).
**          i_name      = 'refx_gw_pp' ).
*
*        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).
*
*        " Initialize the OData Client Proxy
*        DATA(lo_client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
*                                EXPORTING is_proxy_model_key        = VALUE #( repository_id       = 'DEFAULT'
*                                                                               proxy_model_id      = 'ZREFX_ECC_VENDOR_DETAILS'
*                                                                               proxy_model_version = '0001' )
*                                          io_http_client            = lo_http_client
*                                          iv_relative_service_root  = '/sap/opu/odata/sap/ZREFX_API_CMPCLM_SRV/'
*                                         ).
*
*        " Create the Read Request for the specific Entity Set
*        DATA(lo_read_request) = lo_client_proxy->create_resource_for_entity_set( 'VENDOR_DETAILS_SET' )->create_request_for_read( ).
*
*        " Map the RAP filter to the OData $filter=VendorEmailId eq 'user_email'
*        DATA(lo_filter_factory) = lo_read_request->create_filter_factory( ).
*
*        " Create a range table manually for the 'Field' property
*        lt_vendor_range = VALUE #( (  sign   = 'I'
*                                      option = 'EQ'
*                                      low    =  lv_email ) ).
*
*        " Apply this range to the 'Field' property in the OData request
*        DATA(lo_filter) = lo_filter_factory->create_by_range(
*                             iv_property_path = 'VENDOR_EMAIL_ID'
*                             it_range         = lt_vendor_range ).
*
*        lo_read_request->set_filter( lo_filter ).
*
*        " Execute the request
*        TRY.
*            DATA(lo_response) = lo_read_request->execute( ).
*          CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
*            " This will often contain the HTML or JSON error from ECC
*            DATA(lv_error_text) = lx_gateway->get_text( ).
*            " If you are in debug mode, inspect lx_gateway->http_status_code
*        ENDTRY.
*
*        " Retrieve and Map the results
*        " Use the internal structure type generated by your SCM for 'VendorDetailSet'
*        DATA lt_external_data TYPE zrefx_ecc_vendor_details=>tyt_vendor_details. "SCM type
*
*        lo_response->get_business_data( IMPORTING et_business_data = lt_external_data ).
*
*      CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
*        " Error if destination 'refx_gw_ba' is missing in BTP Cockpit
*        RAISE SHORTDUMP lx_dest.
*      CATCH cx_web_http_client_error INTO DATA(lx_http).
*        " Error with network or Cloud Connector connection
*        RAISE SHORTDUMP lx_http.
*      CATCH /iwbep/cx_gateway INTO DATA(lx_proxy).
*        " Error mapping OData results
*        RAISE SHORTDUMP lx_proxy..
*        "handle exception
*    ENDTRY.
*
*    " 3. Read current keys
*    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY claims
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_claims).
*
*    " 4. Update the draft state with ECC data
*    IF lt_external_data IS NOT INITIAL.
*
*      " Read the first matching vendor record returned from ECC
*      DATA(ls_ecc_data) = lt_external_data[ 1 ].
*
*      " Remove leading zeros from Vendor ID
*      ls_ecc_data-Vendor_id = shift_left( val = ls_ecc_data-vendor_id sub = '0' ).
*
*      LOOP AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_claim>).
*        APPEND VALUE #( %tky = <fs_claim>-%tky ) TO lt_update ASSIGNING FIELD-SYMBOL(<fs_modify>).
*        <fs_modify>-Vendorid             = ls_ecc_data-vendor_id.
*        <fs_modify>-Vendorname           = ls_ecc_data-vendor_name.
*        <fs_modify>-Vendorcompanyname    = ls_ecc_data-vendor_company_name.
*        <fs_modify>-Contactpersonname    = ls_ecc_data-contact_person_name.
*        <fs_modify>-Contactmobile        = ls_ecc_data-vendor_mob_number.
**      <fs_modify>-Vendoraltnum         = ls_ecc_data-.
*        <fs_modify>-Vendorregistrationno = ls_ecc_data-vendor_reg_num.
*        <fs_modify>-Contactemail         = ls_ecc_data-vendor_email_id.
**      <fs_modify>-Preferredlanguage    = ls_ecc_data-.
**        <fs_modify>-Vend        = ls_ecc_data-vendor_address.
*      ENDLOOP.
*
*      IF lt_update IS NOT INITIAL.
*        MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
*          ENTITY claims UPDATE FIELDS ( Vendorid Vendorname Vendorcompanyname Contactpersonname
*                                            Contactmobile Vendoraltnum Vendorregistrationno
*                                            Contactemail   ) WITH lt_update. "Vendoraddress ) WITH lt_update.
*      ENDIF.
*
*    ENDIF.
*
*  ENDMETHOD.

*  METHOD fetchVendorDetails.
*    TYPES: BEGIN OF ty_range_line,
*             sign   TYPE c LENGTH 1,
*             option TYPE c LENGTH 2,
*             low    TYPE string,
*             high   TYPE string,
*           END OF ty_range_line,
*           tt_range_tab TYPE STANDARD TABLE OF ty_range_line WITH EMPTY KEY.
*
*    " 1. Read the newly selected Vendorid from the draft
*    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY claims
*        FIELDS ( Vendorid ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_claims).
*
*    DATA lt_update TYPE TABLE FOR UPDATE zrefx_i_claims.
*    DATA lt_external_data TYPE zrefx_ecc_vendor_details=>tyt_vendor_details.
*
*    LOOP AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_claim>) WHERE Vendorid IS NOT INITIAL.
*
*      DATA(lv_padded_vendor) = |{ <fs_claim>-Vendorid ALPHA = IN }|.
*
*      " 2. Fetch the specific Vendor from ECC OData via SCM
*      TRY.
*          DATA(lo_dest) = cl_http_destination_provider=>create_by_cloud_destination( 'refx_gw_ba' ).
**          DATA(lo_dest) = cl_http_destination_provider=>create_by_cloud_destination( 'refx_gw_pp' ).
*          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).
*
*          DATA(lo_client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
*                                    EXPORTING is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
*                                                                                  proxy_model_id      = 'ZREFX_ECC_VENDOR_DETAILS'
*                                                                                  proxy_model_version = '0001' )
*                                              io_http_client           = lo_http_client
*                                              iv_relative_service_root = '/sap/opu/odata/sap/ZREFX_API_CMPCLM_SRV/' ).
*
*          DATA(lo_read_request) = lo_client_proxy->create_resource_for_entity_set( 'VENDOR_DETAILS_SET' )->create_request_for_read( ).
*
*          " Filter by the selected Vendor ID
*          DATA(lo_filter) = lo_read_request->create_filter_factory( )->create_by_range(
*                               iv_property_path = 'VENDOR_ID' " Replace with your exact SCM property name for Vendor ID
*                               it_range         = VALUE tt_range_tab( ( sign = 'I' option = 'EQ' low = lv_padded_vendor ) ) ).
*
*          lo_read_request->set_filter( lo_filter ).
*          DATA(lo_response) = lo_read_request->execute( ).
*          lo_response->get_business_data( IMPORTING et_business_data = lt_external_data ).
*
*          IF lt_external_data IS NOT INITIAL.
*            DATA(ls_ecc_data) = lt_external_data[ 1 ].
*
*            " 3. Map values to update the draft
*            APPEND VALUE #( %tky = <fs_claim>-%tky
*                            Vendorname           = ls_ecc_data-vendor_name
*                            Vendorcompanyname    = ls_ecc_data-vendor_company_name
*                            Contactpersonname    = ls_ecc_data-contact_person_name
*                            Contactmobile        = ls_ecc_data-vendor_mob_number
*                            Vendorregistrationno = ls_ecc_data-vendor_reg_num
*                            Contactemail         = ls_ecc_data-vendor_email_id
**                            Vendoraddress        = ls_ecc_data-vendor_address
*                          ) TO lt_update.
*          ENDIF.
*
*        CATCH cx_root INTO DATA(lx_error) ##NO_HANDLER.
*          " Handle errors if necessary
*      ENDTRY.
*    ENDLOOP.
*
*    " 4. Update the read-only fields IN LOCAL MODE
*    IF lt_update IS NOT INITIAL.
*      MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
*        ENTITY claims UPDATE FIELDS ( Vendorname Vendorcompanyname Contactpersonname
*                                      Contactmobile Vendorregistrationno
*                                      Contactemail  ) WITH lt_update. "Vendoraddress ) WITH lt_update.
*    ENDIF.
*  ENDMETHOD.

*  METHOD validate_Confirminformation.
*    " 1. Read the necessary fields from the draft/active instance
*    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY claims
*        FIELDS ( Confirminformation Consentdate ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_claims).
*
*    LOOP AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_claim>).
*
*      " 2. Clear any previous error messages for this specific validation
*      APPEND VALUE #( %tky        = <fs_claim>-%tky
*                      %state_area = 'VALIDATE_CONSENT' ) TO reported-claims.
*
*      " 3. Check the condition: Checkbox is initial and Date is blank
*      IF <fs_claim>-Confirminformation  IS INITIAL AND <fs_claim>-Consentdate IS INITIAL.
*
*        " 4. Mark the instance as failed so the save process is aborted
*        APPEND VALUE #( %tky = <fs_claim>-%tky ) TO failed-claims.
*
*        " 5. Send the error message to the UI
*        APPEND VALUE #( %tky = <fs_claim>-%tky
*                        %state_area = 'VALIDATE_CONSENT'
*                        %msg = new_message_with_text(
*                                 text = 'Kindly Maintain Confirmation'
*                                 severity = if_abap_behv_message=>severity-error
*                               )
*                        " 6. This highlights the 'Consentdate' field in red on the Fiori screen
*                        %element-Consentdate         = if_abap_behv=>mk-on
*                        %element-Confirminformation  = if_abap_behv=>mk-on
*                      ) TO reported-claims.
*      ENDIF.
*
*      " 7. Check the condition: Checkbox is ticked ('X') but Date is blank
*      IF <fs_claim>-Confirminformation = abap_true AND <fs_claim>-Consentdate IS INITIAL.
*
*        " 8. Mark the instance as failed so the save process is aborted
*        APPEND VALUE #( %tky = <fs_claim>-%tky ) TO failed-claims.
*
*        " 9. Send the error message to the UI
*        APPEND VALUE #( %tky = <fs_claim>-%tky
*                        %state_area = 'VALIDATE_CONSENT'
*                        %msg = new_message_with_text(
*                                 text = 'Kindly Maintain Consent Date!'
*                                 severity = if_abap_behv_message=>severity-error
*                               )
*                        " 10. This highlights the 'Consentdate' field in red on the Fiori screen
*                        %element-Consentdate         = if_abap_behv=>mk-on
*                      ) TO reported-claims.
*      ENDIF.
*
*    ENDLOOP.
*
*
*  ENDMETHOD.
*
*  METHOD validateMandatoryFields.
*    " 1. Read the fields we need to validate from the draft
*    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY claims
*        FIELDS ( Claimcategory Vendorid ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_claims).
*
*    LOOP AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_claim>).
*
*      " 2. Clear any previous error messages for this specific validation
*      APPEND VALUE #( %tky        = <fs_claim>-%tky
*                      %state_area = 'VALIDATE_MANDATORY' ) TO reported-claims.
*
*      " 4. Check Vendor ID
*      IF <fs_claim>-Vendorid IS INITIAL.
*        APPEND VALUE #( %tky = <fs_claim>-%tky ) TO failed-claims.
*
*        APPEND VALUE #( %tky = <fs_claim>-%tky
*                        %state_area = 'VALIDATE_MANDATORY'
*                        %msg = new_message_with_text(
*                                 text     = 'Vendor ID is mandatory.'
*                                 severity = if_abap_behv_message=>severity-error )
*                        " Highlights the specific field in red on the UI
*                        %element-Vendorid = if_abap_behv=>mk-on
*                      ) TO reported-claims.
*      ENDIF.
*
*
*      " 3. Check Claim Category
*      IF <fs_claim>-Claimcategory IS INITIAL.
*        APPEND VALUE #( %tky = <fs_claim>-%tky ) TO failed-claims.
*
*        APPEND VALUE #( %tky = <fs_claim>-%tky
*                        %state_area = 'VALIDATE_MANDATORY'
*                        %msg = new_message_with_text(
*                                 text     = 'Claim Category is mandatory.'
*                                 severity = if_abap_behv_message=>severity-error )
*                        " Highlights the specific field in red on the UI
*                        %element-Claimcategory = if_abap_behv=>mk-on
*                      ) TO reported-claims.
*      ENDIF.
*
*
*
**       " 4. Check Claim Type
**      IF <fs_claim>-Claimtype IS INITIAL.
**        APPEND VALUE #( %tky = <fs_claim>-%tky ) TO failed-claims.
**
**        APPEND VALUE #( %tky = <fs_claim>-%tky
**                        %state_area = 'VALIDATE_MANDATORY'
**                        %msg = new_message_with_text(
**                                 text     = 'Claim Type is mandatory.'
**                                 severity = if_abap_behv_message=>severity-error )
**                        " Highlights the specific field in red on the UI
**                        %element-Vendorid = if_abap_behv=>mk-on
**                      ) TO reported-claims.
**      ENDIF.
*
*
*    ENDLOOP.
*
*
*  ENDMETHOD.

  METHOD UpdateDivision.
    " Use the specific type generated by the BDEF for this action's result
    DATA: lt_action_result TYPE TABLE FOR ACTION RESULT zrefx_i_claims~UpdateDivision.
    " 1. Read the parameters passed from SBPA
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
    IF sy-subrc = 0.

      " 2. Update the record using LOCAL MODE (bypasses UI read-only locks)
      MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
        ENTITY claims
          UPDATE FIELDS (
          MainDivision
          Legalflag
          PaymentTerm
          BudgetCheck
          )
          WITH VALUE #( (
*          %tky         = <fs_key>-%tky
                          Claimid      = <fs_key>-%param-Claim_id
                          MainDivision = <fs_key>-%param-MainDivision
                          Legalflag    = <fs_key>-%param-Legalflag
                          PaymentTerm  = <fs_key>-%param-PaymentTerm
                          BudgetCheck  = <fs_key>-%param-BudgetCheck
                           ) ).

      " 3. Return the updated record back to the caller
*      READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*        ENTITY claims
*
*        ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_claims).


      READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
               ENTITY claims
                 ALL FIELDS WITH VALUE #( ( Claimid = <fs_key>-%param-Claim_id ) )
               RESULT DATA(lt_results).


*      result = VALUE #( FOR clm IN lt_claims ( %tky = clm-%tky %param = clm ) ).
      LOOP AT lt_results INTO DATA(ls_res).
        APPEND VALUE #( %param = CORRESPONDING #( ls_res ) ) TO lt_action_result.
      ENDLOOP.
      result = lt_action_result.



    ENDIF.
  ENDMETHOD.

*  METHOD UpdateWorkflowInfo.
*    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
*    IF sy-subrc = 0.
*
*      " Append a NEW line item for this approval step from SBPA
*      MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
*        ENTITY claims
*          CREATE BY \_WorkflowInfo
*          FIELDS ( WfInstanceId
*                   ApprovalStep
*                   ApprovalStepDesc
*                   ApproverEmail
*                   CurrentStatus
*                   CurrentOwner
*                   CurrentOwnerDesig
*                   OrganizationField
*                   Comments
*                   DecisionOutcome
*                   SubmissionFromDate
**                   AgingFromDate
*                   )
*
*          WITH VALUE #( ( %tky = <fs_key>-%tky
*                          %target = VALUE #( ( %cid               = 'SBPA_STEP'
*                                               WfInstanceId       = <fs_key>-%param-WfInstanceId
*                                               ApprovalStep       = <fs_key>-%param-ApprovalStep
*                                               ApprovalStepDesc   = <fs_key>-%param-ApprovalStepDesc
*                                               ApproverEmail      = <fs_key>-%param-ApproverEmail
*                                               CurrentStatus      = <fs_key>-%param-CurrentStatus
*                                               CurrentOwner       = <fs_key>-%param-CurrentOwner
*                                               CurrentOwnerDesig  = <fs_key>-%param-CurrentOwnerDesig
*                                               OrganizationField  = <fs_key>-%param-OrganizationField
*                                               Comments           = <fs_key>-%param-Comments
**                                               AuthorityLevel     = <fs_key>-%param-AuthorityLevel
*                                               DecisionOutcome    = <fs_key>-%param-DecisionOutcome
**                                               LegalInvolvement   = <fs_key>-%param-LegalInvolvement
**                                               AgingFromDate = cl_abap_context_info=>get_system_date( ) ) ) ) ).
*                                               SubmissionFromDate = cl_abap_context_info=>get_system_date( ) ) ) ) ).
*
*      " Evaluate the SBPA Status and determine if the Parent Complaint needs to close
*      DATA lv_new_parent_status TYPE string.
*
*      " Checking for both 'REJECT' and 'REJECTED' just to be safe with SBPA payloads
*      IF <fs_key>-%param-CurrentStatus = 'REJECTED' OR <fs_key>-%param-CurrentStatus = 'REJECT'.
*        lv_new_parent_status = 'Rejected'.
*      ELSEIF <fs_key>-%param-CurrentStatus = 'COMPLETED'.
*        lv_new_parent_status = 'Completed'.
*      ENDIF.
*
*      " If the workflow hit a final state, update the Parent Complaint Status
*      IF lv_new_parent_status IS NOT INITIAL.
*        MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
*          ENTITY claims
*            UPDATE FIELDS ( Status )
*            WITH VALUE #( ( %tky = <fs_key>-%tky
*                            Status = lv_new_parent_status ) ).
*      ENDIF.
*
*      " Return the parent entity to satisfy the OData Action response
*      READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*        ENTITY claims ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_claims).
*
*      result = VALUE #( FOR comp IN lt_claims ( %tky = comp-%tky %param = comp ) ).
*
*    ENDIF.
*
*  ENDMETHOD.

*  METHOD SetStatusSubmitted.
*
*    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
*    IF sy-subrc = 0.
*
*      MODIFY ENTITIES OF zrefx_i_claims IN LOCAL MODE
*        ENTITY claims
*          UPDATE FIELDS ( Status )
*          WITH VALUE #( ( %tky = <fs_key>-%tky Status = 'Submitted' ) ).
*
*      " Return the updated record
*      READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*        ENTITY claims ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_claims).
*
*      result = VALUE #( FOR comp IN lt_claims ( %tky = comp-%tky %param = comp ) ).
*
*    ENDIF.
*
*
*
*  ENDMETHOD.

*  METHOD get_instance_features.
**-------------------------------------------------------------------------------*
** Enable and Disable Upload attachment block using DMSID Generation
**-------------------------------------------------------------------------------*
*    "Read the DMS ID to check if the record was already processed by the system
*    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY Attachments
*      FIELDS ( Dmsid ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_attachments).
*
*    result = VALUE #( FOR attachment IN lt_attachments
*                        ( %tky = attachment-%tky
*                          %features-%update = COND #(
*                          " CONDITION 1: It is a brand new record (No ID yet)
*                          " We must allow update so the user can fill initial fields
*                          WHEN attachment-Dmsid IS INITIAL
*                          THEN if_abap_behv=>fc-o-enabled
*
*                          " CONDITION 2: The DMS ID is present.
*                          " This means the background process already ran. Lock it.
*                          ELSE if_abap_behv=>fc-o-disabled )
*                        )
*                    ).

  " 1. Retrieve the current user's email ID from system context
*    TRY.
*        " Get the technical user name (Replacement for SY-UNAME)
*        DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).
*
*        SELECT SINGLE \_WorkplaceAddress-DefaultEmailAddress
*            FROM I_BusinessUserBasic WITH PRIVILEGED ACCESS
*            WHERE UserID = @lv_technical_name
*            INTO @DATA(lv_email).
*
*      CATCH cx_abap_context_info_error INTO DATA(lx_error) ##NO_HANDLER.
*        " Fallback if the system environment fails to retrieve context info
*    ENDTRY.
*
*    " 2. Determine external vendor flag based on the retrieved email address
*    " If the logged-in user's email does not contain '@se.com.sa', External Vendor.
*    IF lv_email NS '@se.com.sa'.
*      DATA(lv_external_vendor) = abap_true.
*    ELSE.
*      lv_external_vendor  = abap_false.
*    ENDIF.
*
*    " 3. Read the incoming instances to match their transaction keys (%tky)
*    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
*      ENTITY claims
*        FIELDS ( Claimid Status ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_claims)
*      FAILED failed.
*
*    " 4. Apply the field control state across all processing instances
*    LOOP AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_claim>).
*
*      " --- UI LOCK LOGIC ---
*      " If the status is running, disable Edit and Delete buttons entirely
*      " This is to be considered for both internal and external users to prevent any tampering while the workflow is running
*      DATA(lv_is_locked) = COND #( WHEN <fs_claim>-Status = 'Submitted'
*                                     OR <fs_claim>-Status = 'Rejected'
*                                     OR <fs_claim>-Status = 'Completed'
*                                   THEN if_abap_behv=>fc-o-disabled
*                                   ELSE if_abap_behv=>fc-o-enabled ).
*
*      IF lv_external_vendor = abap_true.
*        " --- EXTERNAL USER ---
*        " Everything is completely locked; populated purely via background OData API
*        APPEND VALUE #( %tky                       = <fs_claim>-%tky
*                       %update                     = lv_is_locked
*                       %delete                     = lv_is_locked
**                       %action-Edit                = lv_is_locked
*                       %field-Vendorid             = if_abap_behv=>fc-f-read_only
*                       %field-Vendorname           = if_abap_behv=>fc-f-read_only
*                       %field-Vendorcompanyname    = if_abap_behv=>fc-f-read_only
*                       %field-Contactpersonname    = if_abap_behv=>fc-f-read_only
*                       %field-Contactmobile        = if_abap_behv=>fc-f-read_only
*                       %field-Vendoraltnum         = if_abap_behv=>fc-f-read_only
*                       %field-Vendorregistrationno = if_abap_behv=>fc-f-read_only
*                       %field-Contactemail         = if_abap_behv=>fc-f-read_only ) TO result.
**                       %field-Preferredlanguage    = if_abap_behv=>fc-f-read_only
**                       %field-Vendoraddress        = if_abap_behv=>fc-f-read_only ) TO result.
*      ELSE.
*        " --- INTERNAL USER ---
*        " Can type or use F4 on Vendor ID, but cannot manually tamper with details fields
*        APPEND VALUE #( %tky                       = <fs_claim>-%tky
*                       %update                     = lv_is_locked
*                       %delete                     = lv_is_locked
**                       %action-Edit                = lv_is_locked
*                       %field-Vendorid             = if_abap_behv=>fc-f-mandatory
*                       %field-Vendorname           = if_abap_behv=>fc-f-read_only
*                       %field-Vendorcompanyname    = if_abap_behv=>fc-f-read_only
*                       %field-Contactpersonname    = if_abap_behv=>fc-f-read_only
*                       %field-Contactmobile        = if_abap_behv=>fc-f-read_only
*                       %field-Vendoraltnum         = if_abap_behv=>fc-f-read_only
*                       %field-Vendorregistrationno = if_abap_behv=>fc-f-read_only
*                       %field-Contactemail         = if_abap_behv=>fc-f-read_only ) TO result.
**                       %field-Preferredlanguage    = if_abap_behv=>fc-f-read_only
**                      %field-Vendoraddress        = if_abap_behv=>fc-f-read_only ) TO result.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.

ENDCLASS.
