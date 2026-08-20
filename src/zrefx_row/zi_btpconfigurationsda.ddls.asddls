@EndUserText.label: 'BTP Configurations Data'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_BtpConfigurationsDa
  as select from ZREFX_ROW_CONFIG
  association to parent ZI_BtpConfigurationsDa_S as _BtpConfigurationAll on $projection.SingletonID = _BtpConfigurationAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key OBJECT_ID as ObjectId,
  ENVIRONMENT as Environment,
  CONFIG_VALUE as ConfigValue,
  DESCRIPTION as Description,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
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
  @Consumption.hidden: true
  LOC_CHANGED_AT as LocChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _BtpConfigurationAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
}
