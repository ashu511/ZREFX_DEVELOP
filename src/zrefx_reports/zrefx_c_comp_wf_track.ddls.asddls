@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for Complaints Workflow Track'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZREFX_C_COMP_WF_TRACK
  provider contract transactional_query
  as projection on ZREFX_I_COMP_WF_TRACK
{
  key ComplaintId,
      @UI.hidden: true
  key LogUuid,
      //      WfInstanceId,
      @UI.hidden: true
      Category,
      @UI.hidden: true
      Source,
      Region,
      Maindivision,
      Legalflag,
      ApprovalStep,
      ApprovalStepDesc,
      @UI.hidden: true
      ApproverEmail,
      CurrentStatus,
      CurrentOwner,
      DaysOpen,
      SlaStatus,
      SubmissionFromDate,
      SubmissionToDate,
      @UI.hidden: true
      EscalationTriggered,
      @UI.hidden: true
      AuthorityLevel,
      @UI.hidden: true
      DaysPending,
      @UI.hidden: true
      EscalationDate,
      @UI.hidden: true
      LegalInvolvement,
      @UI.hidden: true
      DecisionOutcome,
      @UI.hidden: true
      LegalReviewReq,
      @UI.hidden: true
      LegalDecision,
      @UI.hidden: true
      FinalDecision,
      @UI.hidden: true
      ClosureDate

      //      /* Associations */
      //      _Complaints
}
