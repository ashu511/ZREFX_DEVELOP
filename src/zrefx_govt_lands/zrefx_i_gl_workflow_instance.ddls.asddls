@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for GL WF Instance'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_GL_WORKFLOW_INSTANCE
  as select from zrefx_gl_workin
  association to parent ZREFX_I_GL_REQUEST as _GLRequest on $projection.RequestId = _GLRequest.RequestId
{
  key request_id         as RequestId,
  key log_uuid           as LogUuid,
      wf_instance_id     as WfInstanceId,
      objecttype         as Objecttype,
      approvalstep       as Approvalstep,
      approvalstepdesc   as Approvalstepdesc,
      approver_email     as ApproverEmail,
      current_status     as CurrentStatus,
      current_owner      as CurrentOwner,
      currentownerdesig  as Currentownerdesig,
      organization_field as OrganizationField,
      comments           as Comments,
      region             as Region,
      submission_date    as SubmissionDate,
      decision_outcome   as DecisionOutcome,
      _GLRequest
}
