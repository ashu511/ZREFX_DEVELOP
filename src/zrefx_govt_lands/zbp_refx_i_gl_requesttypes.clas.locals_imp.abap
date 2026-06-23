CLASS lhc_ZREFX_I_GL_REQUESTTYPES DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrefx_i_gl_requesttypes RESULT result.

ENDCLASS.

CLASS lhc_ZREFX_I_GL_REQUESTTYPES IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
