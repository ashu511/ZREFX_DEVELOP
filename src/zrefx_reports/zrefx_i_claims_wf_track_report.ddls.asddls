@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Claims Workflow Tracking Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_CLAIMS_WF_TRACK_REPORT
  as select from ZREFX_I_CLAIMS_WF_ALL_STEPS
  association to zrefx_claims as _Claims on $projection.ClaimId = _Claims.claim_id
{

  key ZREFX_I_CLAIMS_WF_ALL_STEPS.ClaimId,
  key ZREFX_I_CLAIMS_WF_ALL_STEPS.LogUuid,
  _Claims.claimcategory as ClaimCategory,            
      ZREFX_I_CLAIMS_WF_ALL_STEPS.WfInstanceId,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.Region,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.ApprovalStep,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.CurrentStatus,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.CurrentOwner,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.SubmissionFromDate,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.SubmissionToDate,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.SlaStatus,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.DaysOpen,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.SettlementStatus,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.PostingFromDate,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.PostingToDate,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.PaymentStatus,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      ZREFX_I_CLAIMS_WF_ALL_STEPS.ApprovedAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      ZREFX_I_CLAIMS_WF_ALL_STEPS.PostedAmount,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.CurrencyCode,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.AccountDocNo,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.PaymentDate,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.AgingFromDate,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.AgingToDate,
      ZREFX_I_CLAIMS_WF_ALL_STEPS.EscalationFlag
      

      //  key claim_id             as ClaimId,
      //      wf_instance_id       as WfInstanceId,
      //      region               as Region,
      //      current_status       as CurrentStatus,
      //      current_owner        as CurrentOwner,
      //      submission_from_date as SubmissionFromDate,
      //      submission_to_date   as SubmissionToDate,
      //      sla_status           as SlaStatus,
      //      days_open            as DaysOpen,
      //      settlement_status    as SettlementStatus,
      //      posting_from_date    as PostingFromDate,
      //      posting_to_date      as PostingToDate,
      //      payment_status       as PaymentStatus,
      //      @Semantics.amount.currencyCode: 'CurrencyCode'
      //      approved_amount      as ApprovedAmount,
      //      @Semantics.amount.currencyCode: 'CurrencyCode'
      //      posted_amount        as PostedAmount,
      //      currency_code        as CurrencyCode,
      //      account_doc_no       as AccountDocNo,
      //      payment_date         as PaymentDate,
      //      aging_from_date      as AgingFromDate,
      //      aging_to_date        as AgingToDate,
      //      escalation_flag      as EscalationFlag,
      //
      //      _Claims

}
