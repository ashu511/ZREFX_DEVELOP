CLASS lhc_ZREFX_I_ROW_CONFIGS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zrefx_i_row_configs RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zrefx_i_row_configs RESULT result.

    METHODS setNumberRange FOR MODIFY
       keys FOR ACTION zrefx_i_row_configs~setNumberRange.

ENDCLASS.

CLASS lhc_ZREFX_I_ROW_CONFIGS IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setNumberRange.

   DATA(lv_created) = zrefx_cl_nr_generator=>ensure_interval_exists( ).

  IF lv_created = abap_true.

    APPEND VALUE #( %msg = new_message_with_text(
                       severity = if_abap_behv_message=>severity-success
                       text     = text-001
                   ) ) TO reported-zrefx_i_ROW_configs.

  ELSE.

    APPEND VALUE #( %msg = new_message_with_text(
                       severity = if_abap_behv_message=>severity-information
                       text     =  text-002
                   ) ) TO reported-zrefx_i_ROW_configs.

  ENDIF.
  ENDMETHOD.

ENDCLASS.
