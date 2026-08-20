@EndUserText.label: 'BTP Configurations Data Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Semantics.valueRange.maximum: '1'
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'BtpConfigurationAll'
  }
}
define root view entity ZI_BtpConfigurationsDa_S
  as select from I_Language
    left outer join ZREFX_ROW_CONFIG on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_BtpConfigurationsDa as _BtpConfigurationsDa
{
  @UI.facet: [ {
    id: 'BtpConfigurationsDa', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'BTP Configurations Data', 
    position: 1 , 
    targetElement: '_BtpConfigurationsDa'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _BtpConfigurationsDa,
  @UI.hidden: true
  max( ZREFX_ROW_CONFIG.CHANGED_AT ) as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 1 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
}
where I_Language.Language = $session.system_language
