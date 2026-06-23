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
         //  key domain_name,
         //  key value_position,
         //      @Semantics.language: true
         //  key language,
         //     value_low as Value,
         //      @Semantics.text: true
         //      text      as Description

  key    value_low as Value,
         @Semantics.language: true
  key    language,
         @Semantics.text: true
         text      as Description

}
