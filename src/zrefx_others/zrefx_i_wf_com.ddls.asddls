@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Complaint Workflow Info'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_WF_COM
  as select from zrefx_wf_com
  association to parent ZREFX_I_COMPLAINTS as _Complaints on $projection.ComplaintId = _Complaints.ComplaintId
{
  key complaint_id         as ComplaintId,
  key log_uuid             as LogUuid,
      wf_instance_id       as WfInstanceId,
      approvalstep         as ApprovalStep,
      approvalstepdesc     as ApprovalStepDesc,
      approver_email       as ApproverEmail,
      current_status       as CurrentStatus,
      current_owner        as CurrentOwner,
      current_owner_desig  as CurrentOwnerDesig,
      organization_field   as OrganizationField,
      comments             as Comments,
      days_open            as DaysOpen,
      sla_status           as SlaStatus,
      submission_from_date as SubmissionFromDate,
      submission_to_date   as SubmissionToDate,
      escalation_triggered as EscalationTriggered,
      authority_level      as AuthorityLevel,
      days_pending         as DaysPending,
      escalation_date      as EscalationDate,
      legal_involvement    as LegalInvolvement,
      decision_outcome     as DecisionOutcome,
      legal_review_req     as LegalReviewReq,
      legal_decision       as LegalDecision,
      final_decision       as FinalDecision,
      closure_date         as ClosureDate,
      /* Associations */
      _Complaints
}
