@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Legal and Aunthority Matrix Interface view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_COMP_Authority_report as select from zrefx_wf_com
  association to zrefx_complaints as _Complaints on $projection.ComplaintId = _Complaints.complaint_id
{
  key complaint_id         as ComplaintId,
    key log_uuid                      as Loguuid,
      wf_instance_id       as WfInstanceId,
      _Complaints.complaintcategory as Category,
      _Complaints.sourcechannel     as Source,
      _Complaints.region            as Region,
      _Complaints.maindivision      as Maindivision,
      _Complaints.legalflag         as Legalflag,
      current_status       as CurrentStatus,
      current_owner        as CurrentOwner,
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
      _Complaints

}
