CLASS lhc_ZREFX_I_GL_CONFIGS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrefx_i_gl_configs RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zrefx_i_gl_configs RESULT result.

    METHODS setNumberRange FOR MODIFY
      IMPORTING keys FOR ACTION zrefx_i_gl_configs~setNumberRange.

ENDCLASS.

CLASS lhc_ZREFX_I_GL_CONFIGS IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setNumberRange.
  ENDMETHOD.

ENDCLASS.
