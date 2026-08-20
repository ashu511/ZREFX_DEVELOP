@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for ROW WF Instance'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_WORKFLOW_INSTANCE
  as select from zrefx_row_workin
  association to ZREFX_I_ROW_STATUS         as _Status     on $projection.Statuscode = _Status.Code
  association to parent ZREFX_I_ROW_REQUEST as _ROWRequest on $projection.RequestId = _ROWRequest.RequestId
{

  key objectid                  as Objectid,
  key request_id                as RequestId,
      wf_instance_id            as WfInstanceId,
      approvalstep              as Approvalstep,
      approvalstepdesc          as Approvalstepdesc,
      approver_email            as ApproverEmail,
      current_status            as CurrentStatus,
      current_owner             as CurrentOwner,
      currentownerdesig         as Currentownerdesig,
      organization_field        as OrganizationField,
      region                    as Region,
      submission_date           as SubmissionDate,

      decision_outcome          as DecisionOutcome,
      objecttype                as Objecttype,
      definitionid              as Definitionid,
      instanceid                as Instanceid,
      _Status._Text.Description as Status,
      statuscode                as Statuscode,
      createdby                 as CreatedBy,
      actiondate                as ActionDate,
      comments                  as Comments,
      department                as Department,
      userid                    as UserId,
      username                  as UserName,
      title                     as Title,
      divemplid                 as DivisionEmployeeId,
      divemplname               as DivisionEmployeeName,
      businessarea              as BusinessArea,
      divmanagerid              as DivisionManagerId,
      divmanagername            as DivisionManagerName,

      _Status,
      _ROWRequest
}
