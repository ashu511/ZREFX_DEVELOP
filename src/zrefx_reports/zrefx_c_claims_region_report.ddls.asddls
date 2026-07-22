@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Claim Region report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZREFX_C_CLAIMS_REGION_REPORT
  provider contract transactional_query
  as projection on ZREFX_I_CLAIMS_REGION_REPORT
{
  key ClaimId,
      CurrentOwner,
      Region,
      SlaStatus,
      DaysOpen,
      AgingFromDate,
      AgingToDate,
      EscalationFlag
}
