@EndUserText.label: 'Maintain Complaints App Configuration'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZC_ComplaintsConfig
  as projection on ZI_ComplaintsConfig
{
  key ObjectId,
  key Environment,
  ConfigValue,
  Description,
  @ObjectModel.text.element: [ 'ConfigurationDeprecation_Text' ]
  ConfigDeprecationCode,
  ChangedAt,
  @Consumption.hidden: true
  LocChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _CompConfigAll : redirected to parent ZC_ComplaintsAppConfig_S,
  ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText.ConfignDeprecationCodeName as ConfigurationDeprecation_Text : localized
}
