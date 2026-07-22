@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for Complaints Workflow Track'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZREFX_C_COMP_WF_TRACK
  provider contract transactional_query
  as projection on ZREFX_I_COMP_WF_TRACK
{
  key ComplaintId,
  key LogUuid,
//      WfInstanceId,
      Category,
      Source,
      Region,
      Maindivision,
      Legalflag,
      ApprovalStep,
      ApprovalStepDesc,
      ApproverEmail,
      
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
      ClosureDate
      
//      /* Associations */
//      _Complaints
} 
