@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Claims Tacking Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_CLAIMS_WF_TRACK_REPORT
  provider contract transactional_query
  as projection on ZREFX_I_CLAIMS_WF_TRACK_REPORT
{
  key ClaimId,
      WfInstanceId,
      Region,
      CurrentStatus,
      CurrentOwner,
      SubmissionFromDate,
      SubmissionToDate,
      SlaStatus,
      DaysOpen,
      SettlementStatus,
      PostingFromDate,
      PostingToDate,
      PaymentStatus,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      ApprovedAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      PostedAmount,
      CurrencyCode,
      AccountDocNo,
      PaymentDate,
      AgingFromDate,
      AgingToDate,
      EscalationFlag,
      /* Associations */
      _Claims
}
