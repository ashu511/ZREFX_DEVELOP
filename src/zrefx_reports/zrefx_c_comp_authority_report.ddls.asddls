@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Legal and Aunthority Matrix Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZREFX_C_COMP_AUTHORITY_REPORT
  provider contract transactional_query
  as projection on ZREFX_I_COMP_Authority_report
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
