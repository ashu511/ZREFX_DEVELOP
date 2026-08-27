@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for Workflow Compensation'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_WF_COMPNS as projection on ZREFX_I_WF_COMPNS
{
    key CompensationId,
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
    /* Associations */
    _Compensation  : redirected to parent ZREFX_C_COMPENSATION
}
