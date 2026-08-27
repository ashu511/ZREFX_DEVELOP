@EndUserText.label: 'Maintain Claims App Configuration'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZC_ClaimsConfig
  as projection on ZI_ClaimsConfig
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
  _ClaimsAppConfigAll : redirected to parent ZC_ClaimsAppConfig_S,
  ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText.ConfignDeprecationCodeName as ConfigurationDeprecation_Text : localized
}
