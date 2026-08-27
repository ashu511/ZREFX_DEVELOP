@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Workflow Instance'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZREFX_C_GL_WORKFLOW_INSTANCE
  as projection on ZREFX_I_GL_WORKFLOW_INSTANCE
{
  key RequestId,
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
      SubmissionDate,
      DecisionOutcome,
      /* Associations */

      _GLRequest : redirected to parent ZREFX_C_GL_REQUEST
}
