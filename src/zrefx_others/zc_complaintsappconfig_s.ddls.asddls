@EndUserText.label: 'Maintain Complaints App Configuration Si'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI: {
  headerInfo: {
    typeName: 'CompConfigAll'
  }
}
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_ComplaintsAppConfig_S
  provider contract TRANSACTIONAL_QUERY
  as projection on ZI_ComplaintsAppConfig_S
{
  @UI.facet: [ {
    id: 'ComplaintsConfig', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Complaints App Configuration', 
    position: 1 , 
    targetElement: '_ComplaintsConfig'
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
  _ComplaintsConfig : redirected to composition child ZC_ComplaintsConfig
}
