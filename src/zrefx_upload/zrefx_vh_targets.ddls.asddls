@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Target Objects Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZREFX_VH_TARGETS
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZREFX_DOM_TARGET' )
{
  key value_low as Value,
      @Semantics.language: true
      @UI.hidden: true
  key language,
      @Semantics.text: true
      text      as Description
}
where language = $session.system_language
