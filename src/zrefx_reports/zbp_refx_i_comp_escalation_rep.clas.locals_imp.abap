CLASS lhc_ZREFX_I_COMP_ESCALATION_RE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zrefx_i_comp_escalation_rep RESULT result.

ENDCLASS.

CLASS lhc_ZREFX_I_COMP_ESCALATION_RE IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
