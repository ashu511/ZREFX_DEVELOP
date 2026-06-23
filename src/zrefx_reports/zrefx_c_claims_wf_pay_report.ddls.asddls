@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for Patment and Settlement report for Claim'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_CLAIMS_WF_PAY_REPORT
  provider contract transactional_query
  as projection on ZREFX_I_CLAIMS_WF_PAY_REPORT
{
  key ClaimId,
      WfInstanceId,
      VendorName,
      VendorId,
      PostingFromDate,
      PostingToDate,
      PaymentStatus,
      CurrencyCode,
      AccountDocNo,
      PaymentDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      PostedAmount,
      /* Associations */
      _Claims
}
