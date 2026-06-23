CLASS lhc_ZREFX_I_COMP_Authority_rep DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZREFX_I_COMP_Authority_report RESULT result.

ENDCLASS.

CLASS lhc_ZREFX_I_COMP_Authority_rep IMPLEMENTATION.

  METHOD get_global_authorizations.

  ENDMETHOD.

ENDCLASS.
