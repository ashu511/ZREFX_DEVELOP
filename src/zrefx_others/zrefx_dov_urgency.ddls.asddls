@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'REFX Urgency View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}

define view entity ZREFX_DOV_URGENCY
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZREFX_DO_URGENCY' )
{
         @EndUserText.label: 'Urgency'
  key    value_low as Value,
         @Semantics.language: true
         @UI.hidden: true
  key    language,
         @EndUserText.label: 'Description'
         @Semantics.text: true
         text      as Description
}
where
  language = $session.system_language
