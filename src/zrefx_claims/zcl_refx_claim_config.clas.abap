CLASS zcl_refx_claim_config DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    " Factory method to get the singleton instance
    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_refx_claim_config.

    " Data retrieval methods
    METHODS get_sbpa_destination RETURNING VALUE(rv_value) TYPE string.
    METHODS get_wf_definition_id RETURNING VALUE(rv_value) TYPE string.
    METHODS get_sbpa_api_key     RETURNING VALUE(rv_value) TYPE string.
    METHODS get_wf_environment_id RETURNING VALUE(rv_value) TYPE string.
    METHODS get_dms_repository_id RETURNING VALUE(rv_value) TYPE string.
    METHODS get_sbpa_inbox_url RETURNING VALUE(rv_value) TYPE string.

  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO zcl_refx_claim_config.
ENDCLASS.

CLASS zcl_refx_claim_config IMPLEMENTATION.

  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.

  METHOD get_sbpa_destination.
    SELECT SINGLE config_value FROM zrefx_clm_config
      WHERE object_id = 'BTP_SBPA_DEST'
        AND environment = @sy-sysid
        AND configdeprecationcode <> 'E'
      INTO @rv_value.
  ENDMETHOD.

  METHOD get_wf_definition_id.
    SELECT SINGLE config_value FROM zrefx_clm_config
      WHERE object_id = 'WF_DEF_ID'
        AND environment = @sy-sysid
        AND configdeprecationcode <> 'E'
      INTO @rv_value.
  ENDMETHOD.

  METHOD get_sbpa_api_key.
    SELECT SINGLE config_value FROM zrefx_clm_config
      WHERE object_id = 'SBPA_API_KEY'
        AND environment = @sy-sysid
        AND configdeprecationcode <> 'E'
      INTO @rv_value.
  ENDMETHOD.

  METHOD get_wf_environment_id.
    SELECT SINGLE config_value FROM zrefx_clm_config
      WHERE object_id = 'WF_ENV_ID'
        AND environment = @sy-sysid
        AND configdeprecationcode <> 'E'
      INTO @rv_value.
  ENDMETHOD.

  METHOD get_dms_repository_id.
    SELECT SINGLE config_value FROM zrefx_clm_config
      WHERE object_id = 'REPOSITORY_ID'
        AND environment = @sy-sysid
        AND configdeprecationcode <> 'E'
      INTO @rv_value.
  ENDMETHOD.

  METHOD get_sbpa_inbox_url.
    SELECT SINGLE config_value FROM zrefx_clm_config
      WHERE object_id = 'INBOX_URL'
        AND environment = @sy-sysid
        AND configdeprecationcode <> 'E'
      INTO @rv_value.
  ENDMETHOD.

ENDCLASS.
