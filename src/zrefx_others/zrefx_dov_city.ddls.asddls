@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View On Complaint Category'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}

define view entity ZREFX_DOV_CITY
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZREFX_DO_CITY' )
{
      //  key domain_name,
      //  key value_position,
  key value_low as Value,
      @Semantics.language: true
      @UI.hidden: true
  key language,
      @Semantics.text: true
      text      as City
}
where
  language = $session.system_language
