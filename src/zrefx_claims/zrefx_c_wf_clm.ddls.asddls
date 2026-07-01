@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Workflow Info Projection'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_WF_CLM
  as projection on ZREFX_I_WF_CLM
{
  key ClaimId,
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
      Region,
      SubmissionFromDate,
      SubmissionToDate,
      DecisionOutcome,
      SlaStatus,
      DaysOpen,
      SettlementStatus,
      PostingFromDate,
      PostingToDate,
      PaymentStatus,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      ApprovedAmount,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      PostedAmount,
      CurrencyCode,
      AccountDocNo,
      PaymentDate,
      AgingFromDate,
      AgingToDate,
      EscalationFlag,
      _Claims : redirected to parent ZREFX_C_CLAIMS

}
