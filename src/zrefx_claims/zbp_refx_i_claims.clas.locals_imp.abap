CLASS lsc_zrefx_i_claims DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zrefx_i_claims IMPLEMENTATION.
  METHOD save_modified.
    DATA lv_number_raw TYPE cl_numberrange_runtime=>nr_number. "value from number range

    " Variables to Trigger the SBPA for created complaints
    DATA: lo_operation TYPE REF TO zcl_refx_bgpf_claims_sbpa,
          lo_process   TYPE REF TO if_bgmc_process_single_op,
          lx_bgmc      TYPE REF TO cx_bgmc.

    " Variables for DMS Background Process
    DATA: lo_dms_op     TYPE REF TO zcl_refx_bgpf_claim_dms_up,
          lt_dms_create TYPE zcl_refx_bgpf_claim_dms_up=>tt_context,
          lo_dms_del    TYPE REF TO zcl_refx_bgpf_dms_att_delete,
          lt_dms_delete TYPE zcl_refx_bgpf_dms_att_delete=>tt_context.

*-------------------------------------------------------------------------------*
*                      Create Claim and trigger SBPA Workflow
*-------------------------------------------------------------------------------*
    LOOP AT create-claims ASSIGNING FIELD-SYMBOL(<fs_claims>). "REFERENCE INTO DATA(map).
      TRY.
          " 1. Create an operation instance
          lo_operation = NEW zcl_refx_bgpf_claims_sbpa( ).

          " 2. Set the context data - this will be passed to the SBPA workflow
          DATA(lv_user_id) = cl_abap_context_info=>get_user_technical_name( ).

          lo_operation->set_context_data( claimid      = <fs_claims>-Claimid
                                          claim_type   = <fs_claims>-Claimtype
                                          claim_ref_no = <fs_claims>-Claimreferenceno
                                          claim_amount = <fs_claims>-Claimamount
                                           ).

          " 3. Get the bgPF process factory and create a process
          lo_process = cl_bgmc_process_factory=>get_default( )->create( ).

          " 4. Set a name for monitoring and inject the operation
          lo_process->set_name( 'CallClaimsBPA' )->set_operation( lo_operation ).

          " 5. Save for execution (the actual trigger happens after COMMIT)
          lo_process->save_for_execution( ).

        CATCH cx_bgmc INTO lx_bgmc.
          " Handle registration errors here
      ENDTRY.
    ENDLOOP.
*-------------------------------------------------------------------------------*
*                              Create Attachment
*-------------------------------------------------------------------------------*
    IF create-attachments IS NOT INITIAL.

      LOOP AT create-attachments ASSIGNING FIELD-SYMBOL(<lfs_attachment>).

        "Skip if there's no content to upload
        IF <lfs_attachment>-content IS INITIAL.
          CONTINUE.
        ENDIF.

        APPEND VALUE #(
          claimid  = <lfs_attachment>-ClaimId
          attachmentid = <lfs_attachment>-attachmentid
          content      = <lfs_attachment>-content
          filename     = <lfs_attachment>-filename
          mimetype     = <lfs_attachment>-mimetype
        ) TO lt_dms_create.

      ENDLOOP.

      "Only schedule BgPF if we actually have files to process
      IF lt_dms_create IS NOT INITIAL.

        TRY.

            lo_dms_op = NEW zcl_refx_bgpf_claim_dms_up( ).

            lo_dms_op->set_context_data( it_context = lt_dms_create ).

            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentUpload' )->set_operation( lo_dms_op )->save_for_execution( ).

          CATCH cx_bgmc INTO lx_bgmc.

            " Handle queue registration failure

        ENDTRY.

      ENDIF.

    ENDIF.
*-------------------------------------------------------------------------------*
*                              Delete Attachment
*-------------------------------------------------------------------------------*

    IF delete-attachments IS NOT INITIAL.

      LOOP AT delete-attachments ASSIGNING FIELD-SYMBOL(<lfs_delete>).

        "Skip if there's no attachment or complaint id - both are required to identify the file to delete
        IF <lfs_delete>-AttachmentId IS INITIAL AND <lfs_delete>-ClaimId IS INITIAL.
          CONTINUE.
        ENDIF.

        APPEND VALUE #(
          claimid  = <lfs_delete>-ClaimId
          attachmentid = <lfs_delete>-attachmentid
        ) TO lt_dms_delete.

      ENDLOOP.

      "Only schedule BgPF if we actually have files to process
      IF lt_dms_delete IS NOT INITIAL.

        " Fetch the dmsid from your Z-table before passing it to the background process
        SELECT claim_id , attachment_id, dmsid
          FROM zrefx_att_claims
          FOR ALL ENTRIES IN @lt_dms_delete
          WHERE claim_id = @lt_dms_delete-claimid
            AND attachment_id = @lt_dms_delete-attachmentid
          INTO TABLE @DATA(lt_dms_info).

        " Update your context to include the dmsid
        LOOP AT lt_dms_delete ASSIGNING FIELD-SYMBOL(<ls_del>).
          READ TABLE lt_dms_info INTO DATA(ls_info)
            WITH KEY claim_id = <ls_del>-claimid
                     attachment_id = <ls_del>-attachmentid.
          IF sy-subrc = 0.
            <ls_del>-documentid = ls_info-dmsid.
          ENDIF.
        ENDLOOP.

        TRY.

            lo_dms_del = NEW zcl_refx_bgpf_dms_att_delete( ).

            lo_dms_del->set_context_data( it_context = lt_dms_delete ).

            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentDelete' )->set_operation( lo_dms_del )->save_for_execution( ).

          CATCH cx_bgmc INTO lx_bgmc.

            " Handle queue registration failure

        ENDTRY.

      ENDIF.

    ENDIF.

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
        CATCH cx_number_ranges INTO DATA(lx_error).
          RAISE EXCEPTION lx_error.
      ENDTRY.
      <fs_claims>-Claimid = |{ CONV i( lv_number_raw ) }|.
      DATA(current_date) = cl_abap_context_info=>get_system_date( ).
      DATA(current_year) = current_date(4).
      <fs_claims>-Claimid =  |{ 'CLM' } {  current_year } { <fs_claims>-Claimid }|.
      CONDENSE <fs_claims>-Claimid NO-GAPS.
    ENDLOOP.
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
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZREFX_I_CLAIMS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Attachments RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR claims RESULT result.

ENDCLASS.

CLASS lhc_ZREFX_I_CLAIMS IMPLEMENTATION.

  METHOD get_instance_features.
*-------------------------------------------------------------------------------*
* Enable and Disable Upload attachment block using DMSID Generation
*-------------------------------------------------------------------------------*
    "Read the DMS ID to check if the record was already processed by the system
    READ ENTITIES OF zrefx_i_claims IN LOCAL MODE
      ENTITY Attachments
      FIELDS ( Dmsid ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_attachments).

    result = VALUE #( FOR attachment IN lt_attachments
                        ( %tky = attachment-%tky
                          %features-%update = COND #(
                          " CONDITION 1: It is a brand new record (No ID yet)
                          " We must allow update so the user can fill initial fields
                          WHEN attachment-Dmsid IS INITIAL
                          THEN if_abap_behv=>fc-o-enabled

                          " CONDITION 2: The DMS ID is present.
                          " This means the background process already ran. Lock it.
                          ELSE if_abap_behv=>fc-o-disabled )
                        )
                    ).

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
