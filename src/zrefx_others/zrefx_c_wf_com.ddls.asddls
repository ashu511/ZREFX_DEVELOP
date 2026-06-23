@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Workflow Info Projection'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_WF_COM
  as projection on ZREFX_I_WF_COM
{
  key ComplaintId,
  key LogUuid,
      WfInstanceId,
      ApprovalStep,
      ApprovalStepDesc,
      ApproverEmail,
      CurrentStatus,
      CurrentOwner,
      CurrentOwnerDesig,
      OrganizationField,
      Comments,
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
      _Complaints : redirected to parent ZREFX_C_COMPLAINTS
}
