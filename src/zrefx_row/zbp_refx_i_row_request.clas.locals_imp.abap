CLASS lsc_zrefx_i_row_request DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS cleanup_finalize REDEFINITION.
    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zrefx_i_row_request IMPLEMENTATION.

  METHOD cleanup_finalize.
  ENDMETHOD.
  METHOD adjust_numbers.

*    DATA lv_uuid TYPE sysuuid_x16.
*    DATA lv_proposalid TYPE sysuuid_x16.
*
*
*    "--------------------------------------------------
*    " ROOT: LAND REQUEST
*    "--------------------------------------------------
*    LOOP AT mapped-zrefx_i_ROW_request ASSIGNING FIELD-SYMBOL(<ls_req>).
*      IF <ls_req>-RequestId IS INITIAL.
*        DATA lv_new_number TYPE string.
*
*        TRY.
*            lv_new_number = lhc_zrefx_req_attach=>get_next_number( ).
*
*          CATCH cx_number_ranges INTO DATA(lx_error).
*            RAISE SHORTDUMP lx_error.
*
*        ENDTRY.
*        DATA(lv_requesttype) = lsc_ZREFX_I_LANDREQUEST=>get_requesttype( ).
*        DATA(lv_number) = |{ lv_requesttype }{ lv_new_number }|.
*
*        <ls_req>-RequestId = lv_number.
*      ENDIF.
*
*    ENDLOOP.
*    "--------------------------------------------------
*    " CLARIFICATIONS
*    "--------------------------------------------------
*    LOOP AT mapped-zrefx_i_clarifications ASSIGNING FIELD-SYMBOL(<ls_clar>).
*
*      IF <ls_clar>-Id IS INITIAL.
*
*        TRY.
*            <ls_clar>-Id = cl_system_uuid=>create_uuid_x16_static( ).
*
*          CATCH cx_uuid_error.
*            " This satisfies ATC because the exception is caught here.
*            " Since UUID failure is a kernel-level disaster, we abort.
*            RAISE SHORTDUMP TYPE cx_uuid_error.
*        ENDTRY.
*        <ls_clar>-RequestId = <ls_clar>-%tmp-RequestId.
*      ENDIF.
*
*    ENDLOOP.
*
*
*    "--------------------------------------------------
*    " PROPOSAL
*    "--------------------------------------------------
*    LOOP AT mapped-zrefx_i_proposal ASSIGNING FIELD-SYMBOL(<ls_prop>).
*
*      IF <ls_prop>-Id IS INITIAL.
*
*        TRY.
*            <ls_prop>-Id = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error ##NO_HANDLER.
*            " UUID creation should never fail in RAP late numbering
*            " Framework will handle catastrophic system errors
*        ENDTRY.
*        <ls_prop>-RequestId = <ls_prop>-%tmp-RequestId.
*      ENDIF.
*      lv_proposalid = <ls_prop>-Id.
*
*    ENDLOOP.
*
*
*    "--------------------------------------------------
*    " PROPOSED LAND
*    "--------------------------------------------------
*    LOOP AT mapped-zrefx_i_proposedland ASSIGNING FIELD-SYMBOL(<ls_land>).
*
*      IF <ls_land>-Id IS INITIAL.
*
*        TRY.
*            <ls_land>-Id = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error ##NO_HANDLER.
*            " UUID creation should never fail in RAP late numbering
*            " Framework will handle catastrophic system errors
*        ENDTRY.
*        <ls_land>-ProposalId = lv_proposalid.
*        <ls_land>-RequestId = <ls_land>-%tmp-RequestId.
*      ENDIF.
*
*    ENDLOOP.
*
*
*    "--------------------------------------------------
*    " SITE VISIT NOMINATION
*    "--------------------------------------------------
*    LOOP AT mapped-zrefx_i_sitevisitnom ASSIGNING FIELD-SYMBOL(<ls_nom>).
*
*      IF <ls_nom>-id IS INITIAL.
*
*        TRY.
*            <ls_nom>-id = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error ##NO_HANDLER.
*            " UUID creation should never fail in RAP late numbering
*            " Framework will handle catastrophic system errors
*        ENDTRY.
*        <ls_nom>-ProposalId = <ls_nom>-%tmp-ProposalId.
*        <ls_nom>-RequestId = <ls_nom>-%tmp-RequestId.
*        <ls_nom>-ProposalLand_Id = <ls_nom>-%tmp-ProposalLand_Id.
*      ENDIF.
*
*    ENDLOOP.
*
*
*    "--------------------------------------------------
*    " SITE VISIT
*    "--------------------------------------------------
*    LOOP AT mapped-zrefx_i_sitevisit ASSIGNING FIELD-SYMBOL(<ls_site>).
*
*      IF <ls_site>-id IS INITIAL.
*
*        TRY.
*            <ls_site>-id = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error ##NO_HANDLER.
*            " UUID creation should never fail in RAP late numbering
*            " Framework will handle catastrophic system errors
*        ENDTRY.
*        <ls_site>-RequestId = <ls_site>-%tmp-RequestId.
*        <ls_site>-ProposalId = <ls_site>-%tmp-ProposalId.
*        <ls_site>-ProposalLandId = <ls_site>-%tmp-ProposalLandId.
*
*      ENDIF.
*
*    ENDLOOP.
*
*
*    "--------------------------------------------------
*    " SITE VISIT ATTACHMENTS
*    "--------------------------------------------------
*    LOOP AT mapped-zrefx_i_sitevisit_attachments ASSIGNING FIELD-SYMBOL(<ls_satt>).
*
*      IF <ls_satt>-Dmsid IS INITIAL.
**        <ls_satt>-Id = cl_system_uuid=>create_uuid_x16_static( ).
*        <ls_satt>-RequestId = <ls_satt>-%tmp-RequestId.
*        <ls_satt>-ProposalId = <ls_satt>-%tmp-ProposalId.
*        <ls_satt>-ProposalLandId = <ls_satt>-%tmp-ProposalLandId.
*        <ls_satt>-SiteId = <ls_satt>-%tmp-SiteId.
*      ENDIF.
*
*    ENDLOOP.
*
*
*    "--------------------------------------------------
*    " LAND ALLOCATION
*    "--------------------------------------------------
*    LOOP AT mapped-zrefx_i_land_allocation ASSIGNING FIELD-SYMBOL(<ls_alloc>).
*
*     <ls_alloc>-RequestId = <ls_alloc>-%tmp-RequestId.
*
**      IF <ls_alloc>-Id IS INITIAL.
**
**        TRY.
**            <ls_alloc>-Id = cl_system_uuid=>create_uuid_x16_static( ).
**          CATCH cx_uuid_error ##NO_HANDLER.
**            " UUID creation should never fail in RAP late numbering
**            " Framework will handle catastrophic system errors
**        ENDTRY.
**        <ls_alloc>-RequestId = <ls_alloc>-%tmp-RequestId.
**      ENDIF.
*
*    ENDLOOP.
*
*
*
*
*    "--------------------------------------------------
*    " WORKFLOW INSTANCE
*    "--------------------------------------------------
*    LOOP AT mapped-zrefx_i_workflow_instance ASSIGNING FIELD-SYMBOL(<ls_wf>).
*
*      IF <ls_wf>-Objectid IS INITIAL.
*
*        TRY.
*            <ls_wf>-Objectid = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error ##NO_HANDLER.
*            " UUID creation should never fail in RAP late numbering
*            " Framework will handle catastrophic system errors
*        ENDTRY.
*        <ls_wf>-RequestId = <ls_wf>-%tmp-RequestId.
*      ENDIF.
*
*    ENDLOOP.

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
