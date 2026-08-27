@EndUserText.label: 'Claims App Configuration'
@AccessControl.authorizationCheck: #MANDATORY
define view entity ZI_ClaimsConfig
  as select from ZREFX_CLM_CONFIG
  association to parent ZI_ClaimsAppConfig_S as _ClaimsAppConfigAll on $projection.SingletonID = _ClaimsAppConfigAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key OBJECT_ID as ObjectId,
  key ENVIRONMENT as Environment,
  CONFIG_VALUE as ConfigValue,
  DESCRIPTION as Description,
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_ConfignDeprecationCode', 
      element: 'ConfigurationDeprecationCode'
    }, 
    useForValidation: true
  } ]
  CONFIGDEPRECATIONCODE as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  CHANGED_AT as ChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOC_CHANGED_AT as LocChangedAt,
  1 as SingletonID,
  _ClaimsAppConfigAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
}
