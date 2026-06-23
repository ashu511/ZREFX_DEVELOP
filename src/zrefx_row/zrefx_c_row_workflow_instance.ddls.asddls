@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Workflow Instance'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZREFX_C_ROW_WORKFLOW_INSTANCE 
as projection on   ZREFX_I_ROW_WORKFLOW_INSTANCE
{
  key  Objectid,
  key RequestId,
      Objecttype,
      Definitionid,
      Instanceid,
      Statuscode,
      _Status._Text.Description as Status,
      CreatedBy,
      ActionDate,
      Comments,
      Department,
      UserId,
      UserName,
      Title,
      DivisionEmployeeId,
      DivisionEmployeeName,
      BusinessArea,
      DivisionManagerId,
      DivisionManagerName,
      
      _Status,
      _ROWRequest : redirected to parent ZREFX_C_ROW_REQUEST
}
