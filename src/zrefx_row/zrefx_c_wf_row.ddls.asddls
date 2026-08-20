@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Workflow projuction view for ROW'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_WF_ROW as projection on   ZREFX_I_WF_ROW
{
    key RequestId,
    key LogUuid,
    WfInstanceId,
    Approvalstep,
    Approvalstepdesc,
    ApproverEmail,
    CurrentStatus,
    CurrentOwner,
    Currentownerdesig,
    OrganizationField,
    Comments,
    Region,
    SubmissionFromDate,
    SubmissionToDate,
    DecisionOutcome,
    /* Associations */
    
    _RowWorkflow : redirected to parent ZREFX_C_ROW_REQUEST
}
