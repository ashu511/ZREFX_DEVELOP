@EndUserText.label: 'Maintain Claims App Configuration Single'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI: {
  headerInfo: {
    typeName: 'ClaimsAppConfigAll'
  }
}
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_ClaimsAppConfig_S
  provider contract TRANSACTIONAL_QUERY
  as projection on ZI_ClaimsAppConfig_S
{
  @UI.facet: [ {
    id: 'ClaimsAppConfig', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Claims App Configuration', 
    position: 1 , 
    targetElement: '_ClaimsAppConfig'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key SingletonID,
  @UI.hidden: true
  LastChangedAtMax,
  @ObjectModel.text.element: [ 'TransportRequestDescription' ]
  @UI.identification: [ {
    position: 1 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  TransportRequestID,
  @UI.hidden: true
  _ABAPTransportRequestText.TransportRequestDescription : localized,
  _ClaimsAppConfig : redirected to composition child ZC_ClaimsConfig
}
