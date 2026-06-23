CLASS zcl_refx_btp_config_maint DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_object_id   TYPE string,
      ty_environment TYPE string,
      ty_value       TYPE string,
      ty_description TYPE string.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_refx_btp_config_maint IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA : ls_config       TYPE zrefx_btp_config,
           lv_object_id    TYPE zrefx_btp_config-object_id    VALUE 'repository_id',
           lv_environment  TYPE zrefx_btp_config-environment  VALUE 'DV3',
           lv_config_value TYPE zrefx_btp_config-config_value VALUE '2c263705-b35e-47c2-82b2-cfeb4c6345c2',
           lv_description  TYPE zrefx_btp_config-description  VALUE 'DMS Repository ID'.

    ls_config-client        = sy-mandt.
    ls_config-object_id     = lv_object_id.
    ls_config-environment   = lv_environment.
    ls_config-config_value  = lv_config_value.
    ls_config-description   = lv_description.

    UPDATE zrefx_btp_config FROM @ls_config.

    IF sy-subrc <> 0.
      INSERT zrefx_btp_config FROM @ls_config.
      IF sy-subrc = 0.
        out->write( 'Configuration data successfully uploaded to Config Table' ).
      ELSE.
        out->write( 'Error occurred during data upload.' ).
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
