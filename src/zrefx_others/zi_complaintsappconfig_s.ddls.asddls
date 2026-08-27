@EndUserText.label: 'Complaints App Configuration Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Semantics.valueRange.maximum: '1'
define root view entity ZI_ComplaintsAppConfig_S
  as select from I_Language
    left outer join ZREFX_COM_CONFIG on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_ComplaintsConfig as _ComplaintsConfig
{
  key 1 as SingletonID,
  _ComplaintsConfig,
  max( ZREFX_COM_CONFIG.CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
}
where I_Language.Language = $session.system_language
