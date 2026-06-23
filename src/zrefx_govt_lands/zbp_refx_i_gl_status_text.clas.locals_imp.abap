CLASS lhc_ZREFX_I_GL_STATUS_TEXT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrefx_i_gl_status_text RESULT result.

ENDCLASS.

CLASS lhc_ZREFX_I_GL_STATUS_TEXT IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
