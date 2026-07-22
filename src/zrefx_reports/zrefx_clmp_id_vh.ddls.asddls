@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Claims Info'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_CLMP_ID_VH as select from zrefx_claims as _Claims
{
  key claim_id as ClaimId
    
}
