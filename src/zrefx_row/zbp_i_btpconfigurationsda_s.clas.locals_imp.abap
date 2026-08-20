CLASS LHC_BTPCONFIGURATIONALL DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PUBLIC SECTION.
    CONSTANTS:
      CO_ENTITY TYPE abp_entity_name VALUE `ZI_BTPCONFIGURATIONSDA_S`,
      CO_TRANSPORT_OBJECT TYPE mbc_cp_api=>indiv_transaction_obj_name VALUE `ZBTPCONFIGURATIONSDA`,
      CO_AUTHORIZATION_ENTITY TYPE abp_entity_name VALUE `ZI_BTPCONFIGURATIONSDA`.

  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR BtpConfigurationAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION BtpConfigurationAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR BtpConfigurationAll
        RESULT result.
ENDCLASS.

CLASS LHC_BTPCONFIGURATIONALL IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
  mbc_cp_api=>rap_bc_api( )->get_instance_features(
    transport_object   = co_transport_object
    entity             = co_entity
    keys               = REF #( keys )
    requested_features = REF #( requested_features )
    result             = REF #( result )
    failed             = REF #( failed )
    reported           = REF #( reported ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
  mbc_cp_api=>rap_bc_api( )->select_transport_action(
    entity   = co_entity
    keys     = REF #( keys )
    result   = REF #( result )
    mapped   = REF #( mapped )
    failed   = REF #( failed )
    reported = REF #( reported ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  mbc_cp_api=>rap_bc_api( )->get_global_authorizations(
    entity                   = co_authorization_entity
    requested_authorizations = REF #( requested_authorizations )
    result                   = REF #( result )
    reported                 = REF #( reported ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LSC_BTPCONFIGURATIONALL DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION.
ENDCLASS.

CLASS LSC_BTPCONFIGURATIONALL IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
  mbc_cp_api=>rap_bc_api( )->record_changes(
    transport_object = lhc_BtpConfigurationAll=>co_transport_object
    entity           = lhc_BtpConfigurationAll=>co_entity
    create           = REF #( create )
    update           = REF #( update )
    delete           = REF #( delete )
    reported         = REF #( reported ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LHC_BTPCONFIGURATIONSDA DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PUBLIC SECTION.
    CONSTANTS:
      CO_ENTITY TYPE abp_entity_name VALUE `ZI_BTPCONFIGURATIONSDA`.

  PRIVATE SECTION.
    METHODS:
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR BtpConfigurationsDa~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR BtpConfigurationsDa
        RESULT result,
      DEPRECATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION BtpConfigurationsDa~Deprecate
        RESULT result,
      INVALIDATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION BtpConfigurationsDa~Invalidate
        RESULT result,
      COPY FOR MODIFY
        IMPORTING
          KEYS FOR ACTION BtpConfigurationsDa~Copy,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR BtpConfigurationsDa
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR BtpConfigurationsDa
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_BTPCONFIGURATIONALL FOR BtpConfigurationAll~ValidateTransportRequest
          KEYS_BTPCONFIGURATIONSDA FOR BtpConfigurationsDa~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_BTPCONFIGURATIONSDA IMPLEMENTATION.
  METHOD VALIDATEDATACONSISTENCY.
  mbc_cp_api=>rap_bc_api( )->check_consistency(
    entity   = co_entity
    fields_not_initial = VALUE #( ( CONV #( 'ObjectId' ) ) )
    keys     = REF #( keys )
    failed   = REF #( failed )
    reported = REF #( reported ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
  mbc_cp_api=>rap_bc_api( )->get_global_features(
    transport_object   = lhc_BtpConfigurationAll=>co_transport_object
    entity             = co_entity
    requested_features = REF #( requested_features )
    result             = REF #( result )
    reported           = REF #( reported ) ).
  ENDMETHOD.
  METHOD DEPRECATE.
  mbc_cp_api=>rap_bc_api( )->deprecate_entity(
    entity   = co_entity
    keys     = REF #( keys )
    result   = REF #( result )
    mapped   = REF #( mapped )
    failed   = REF #( failed )
    reported = REF #( reported ) ).
  ENDMETHOD.
  METHOD INVALIDATE.
  mbc_cp_api=>rap_bc_api( )->invalidate_entity(
    entity   = co_entity
    keys     = REF #( keys )
    result   = REF #( result )
    mapped   = REF #( mapped )
    failed   = REF #( failed )
    reported = REF #( reported ) ).
  ENDMETHOD.
  METHOD COPY.
  mbc_cp_api=>rap_bc_api( )->copy_by_association(
    entity   = co_entity
    keys     = REF #( keys )
    mapped   = REF #( mapped )
    failed   = REF #( failed )
    reported = REF #( reported ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  mbc_cp_api=>rap_bc_api( )->get_global_authorizations(
    entity                   = lhc_BtpConfigurationAll=>co_authorization_entity
    requested_authorizations = REF #( requested_authorizations )
    result                   = REF #( result )
    reported                 = REF #( reported ) ).
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
  mbc_cp_api=>rap_bc_api( )->get_action_features(
    entity             = co_entity
    keys               = REF #( keys )
    requested_features = REF #( requested_features )
    result             = REF #( result )
    failed             = REF #( failed )
    reported           = REF #( reported ) ).
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
  mbc_cp_api=>rap_bc_api( )->validate_transport_request(
    transport_object = lhc_BtpConfigurationAll=>co_transport_object
    entity           = lhc_BtpConfigurationAll=>co_entity
    validation_keys  = VALUE #( ( REF #( keys_BtpConfigurationAll ) )
                                ( REF #( keys_BtpConfigurationsDa ) ) )
    failed           = REF #( failed )
    reported         = REF #( reported ) ).
  ENDMETHOD.
ENDCLASS.
