CLASS lhc_ZREFX_I_COMP_WF_TRACK DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zrefx_i_comp_wf_track RESULT result.

ENDCLASS.

CLASS lhc_ZREFX_I_COMP_WF_TRACK IMPLEMENTATION.

  METHOD get_global_authorizations.

  ENDMETHOD.

ENDCLASS.
