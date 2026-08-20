@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Workflow Interface view for ROW'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_WF_ROW
  as select from zrefx_wf_row
  association to parent ZREFX_I_ROW_REQUEST as _RowWorkflow on $projection.RequestId = _RowWorkflow.RequestId
{
  key zrefx_wf_row.request_id           as RequestId,
  key zrefx_wf_row.log_uuid             as LogUuid,
      zrefx_wf_row.wf_instance_id       as WfInstanceId,
      zrefx_wf_row.approvalstep         as Approvalstep,
      zrefx_wf_row.approvalstepdesc     as Approvalstepdesc,
      zrefx_wf_row.approver_email       as ApproverEmail,
      zrefx_wf_row.current_status       as CurrentStatus,
      zrefx_wf_row.current_owner        as CurrentOwner,
      zrefx_wf_row.currentownerdesig    as Currentownerdesig,
      zrefx_wf_row.organization_field   as OrganizationField,
      zrefx_wf_row.comments             as Comments,
      zrefx_wf_row.region               as Region,
      zrefx_wf_row.submission_from_date as SubmissionFromDate,
      zrefx_wf_row.submission_to_date   as SubmissionToDate,
      zrefx_wf_row.decision_outcome     as DecisionOutcome,
      _RowWorkflow
}
