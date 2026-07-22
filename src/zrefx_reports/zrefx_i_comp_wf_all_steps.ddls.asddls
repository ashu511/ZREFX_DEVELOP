@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'WF All steps'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_COMP_WF_ALL_STEPS

  as select from    zrefx_wf_com as Log
  // Self-join to find any APPROVE or COMPLETED entries for the exact same step
    left outer join zrefx_wf_com as ApprovedLog on  Log.complaint_id             = ApprovedLog.complaint_id
                                                and Log.approvalstep             = ApprovedLog.approvalstep
                                                and (
                                                   ApprovedLog.current_status    = 'APPROVE'
                                                   or ApprovedLog.current_status = 'COMPLETED'
                                                   or ApprovedLog.current_status = 'REJECT'
                                                 )
{
  key Log.complaint_id         as ComplaintId,
  key Log.log_uuid             as LogUuid,
      Log.approvalstep         as ApprovalStep,
      Log.approvalstepdesc     as ApprovalStepDesc,
      Log.current_status       as CurrentStatus,
      Log.current_owner        as CurrentOwner,
      Log.comments             as Comments,
      Log.closure_date         as ClosureDate,
      Log.days_open            as DaysOpen,
      Log.sla_status           as SlaStatus,
      Log.submission_from_date as SubmissionFromDate,
      Log.submission_to_date   as SubmissionToDate,
      Log.escalation_triggered as EscalationTriggered,
      Log.authority_level      as AuthorityLevel,
      Log.days_pending         as DaysPending,
      Log.escalation_date      as EscalationDate,
      Log.legal_involvement    as LegalInvolvement,
      Log.decision_outcome     as DecisionOutcome,
      Log.legal_review_req     as LegalReviewReq,
      Log.legal_decision       as LegalDecision,
      Log.final_decision       as FinalDecision,
      Log.approver_email       as ApproverEmail


}
where
  // 1. Always include COMPLETED items
        Log.current_status         = 'COMPLETED'
  or    Log.current_status         = 'APPROVE'
  or    Log.current_status         = 'REJECT'

  // 2. Always include TRIGGERED / SUBMITTED items
  or    Log.current_status         = 'SUBMITTED'
  or    Log.approvalstepdesc       = 'TRIGGERED'

  // 3. Include PENDING items ONLY if the LEFT JOIN failed to find an approval
  or(
        Log.current_status         = 'PENDING'
    and ApprovedLog.current_status is null
  )
