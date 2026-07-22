@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Claim Region report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_CLAIMS_REGION_REPORT  as select from zrefx_wf_clm
  association to zrefx_claims as _Claims on $projection.ClaimId = _Claims.claim_id
{
   key zrefx_wf_clm.claim_id as ClaimId,
   
//   key zrefx_wf_clm.log_uuid as LogUuid,
//   zrefx_wf_clm.wf_instance_id as WfInstanceId,
//   zrefx_wf_clm.approvalstep as Approvalstep,
//   zrefx_wf_clm.approvalstepdesc as Approvalstepdesc,
//   zrefx_wf_clm.approver_email as ApproverEmail,
//   zrefx_wf_clm.current_status as CurrentStatus,
   
   zrefx_wf_clm.current_owner as CurrentOwner,
   
//   zrefx_wf_clm.currentownerdesig as Currentownerdesig,
//   zrefx_wf_clm.organization_field as OrganizationField,
//   zrefx_wf_clm.comments as Comments,
   
   zrefx_wf_clm.region as Region,
   
//   zrefx_wf_clm.submission_from_date as SubmissionFromDate,
//   zrefx_wf_clm.submission_to_date as SubmissionToDate,
//   zrefx_wf_clm.decision_outcome as DecisionOutcome,
   
   zrefx_wf_clm.sla_status as SlaStatus,
   
   zrefx_wf_clm.days_open as DaysOpen,
   
//   zrefx_wf_clm.settlement_status as SettlementStatus,
//   zrefx_wf_clm.posting_from_date as PostingFromDate,
//   zrefx_wf_clm.posting_to_date as PostingToDate,
//   zrefx_wf_clm.payment_status as PaymentStatus,
//   zrefx_wf_clm.approved_amount as ApprovedAmount,
//   zrefx_wf_clm.posted_amount as PostedAmount,
//   zrefx_wf_clm.currency_code as CurrencyCode,
//   zrefx_wf_clm.account_doc_no as AccountDocNo,
//   zrefx_wf_clm.payment_date as PaymentDate,
   
   zrefx_wf_clm.aging_from_date as AgingFromDate,
   zrefx_wf_clm.aging_to_date as AgingToDate,
   
   zrefx_wf_clm.escalation_flag as EscalationFlag
}where sla_status != ' '
