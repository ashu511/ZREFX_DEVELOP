@EndUserText.label: 'Claims App Configuration Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Semantics.valueRange.maximum: '1'
define root view entity ZI_ClaimsAppConfig_S
  as select from I_Language
    left outer join ZREFX_CLM_CONFIG on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_ClaimsConfig as _ClaimsAppConfig
{
  key 1 as SingletonID,
  _ClaimsAppConfig,
  max( ZREFX_CLM_CONFIG.CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
}
where I_Language.Language = $session.system_language
