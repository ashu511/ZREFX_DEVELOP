@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Claims Workflow Tracking Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_CLAIMS_WF_TRACK_REPORT
  as select from zrefx_wf_clm
  association to zrefx_claims as _Claims on $projection.ClaimId = _Claims.claim_id
{
  key claim_id             as ClaimId,
      wf_instance_id       as WfInstanceId,
      region               as Region,
      current_status       as CurrentStatus,
      current_owner        as CurrentOwner,
      submission_from_date as SubmissionFromDate,
      submission_to_date   as SubmissionToDate,
      sla_status           as SlaStatus,
      days_open            as DaysOpen,
      settlement_status    as SettlementStatus,
      posting_from_date    as PostingFromDate,
      posting_to_date      as PostingToDate,
      payment_status       as PaymentStatus,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      approved_amount      as ApprovedAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      posted_amount        as PostedAmount,
      currency_code        as CurrencyCode,
      account_doc_no       as AccountDocNo,
      payment_date         as PaymentDate,
      aging_from_date      as AgingFromDate,
      aging_to_date        as AgingToDate,
      escalation_flag      as EscalationFlag,
      
      _Claims

}
