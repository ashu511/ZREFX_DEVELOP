@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View On Language'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}
define view entity  ZREFX_DOV_STATUS as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZREFX_DO_STATUS' )
{
  key value_low as Value,
      @Semantics.language: true
  key language,
      @Semantics.text: true
      text      as LangText
}
