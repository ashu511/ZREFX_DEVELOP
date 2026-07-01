@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Workflow Interface view for Claims'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_WF_CLM
  as select from zrefx_wf_clm
  association to parent ZREFX_I_CLAIMS as _Claims on $projection.ClaimId = _Claims.Claimid
{
  key claim_id             as ClaimId,
  key log_uuid             as LogUuid,
      wf_instance_id       as WfInstanceId,
      approvalstep         as ApprovalStep,
      approvalstepdesc     as ApprovalStepDesc,
      approver_email       as ApproverEmail,
      current_status       as CurrentStatus,
      current_owner        as CurrentOwner,      
      currentownerdesig    as CurrentOwnerDesig,
      organization_field   as OrganizationField,      
      comments             as Comments,
      region               as Region,
      submission_from_date as SubmissionFromDate,
      submission_to_date   as SubmissionToDate,
      decision_outcome     as DecisionOutcome,
      sla_status           as SlaStatus,
      days_open            as DaysOpen,
      settlement_status    as SettlementStatus,
      posting_from_date    as PostingFromDate,
      posting_to_date      as PostingToDate,
      payment_status       as PaymentStatus,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      approved_amount      as ApprovedAmount,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      posted_amount        as PostedAmount,
      currency_code        as CurrencyCode,
      account_doc_no       as AccountDocNo,
      payment_date         as PaymentDate,
      aging_from_date      as AgingFromDate,
      aging_to_date        as AgingToDate,
      escalation_flag      as EscalationFlag,
      _Claims
}
