@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Complaint Escalation Report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZREFX_C_COMP_ESCALATION_REP
  provider contract transactional_query
  as projection on ZREFX_I_COMP_ESCALATION_REP
{
  key ComplaintId,
    key Loguuid,
      WfInstanceId,
      Category,
      Source,
      Region,
      Maindivision,
      Legalflag,
      CurrentStatus,
      CurrentOwner,
      DaysOpen,
      SlaStatus,
      SubmissionFromDate,
      SubmissionToDate,
      EscalationTriggered,
      AuthorityLevel,
      DaysPending,
      EscalationDate,
      LegalInvolvement,
      DecisionOutcome,
      LegalReviewReq,
      LegalDecision,
      FinalDecision,
      ClosureDate,
      /* Associations */
      _Complaints
}
