@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for GL WF Instance'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_GL_WORKFLOW_INSTANCE 
as select from zrefx_gl_workin
 association        to ZREFX_I_GL_STATUS            as _Status        on  $projection.Statuscode = _Status.Code
 association      to parent ZREFX_I_GL_REQUEST as _GLRequest on  $projection.RequestId = _GLRequest.RequestId    
{
    
     key objectid        as Objectid,
    key request_id    as RequestId,
      objecttype      as Objecttype,
      definitionid    as Definitionid,
      instanceid      as Instanceid,
      _Status._Text.Description          as Status,
      statuscode   as Statuscode,
      createdby       as CreatedBy,
      actiondate     as ActionDate,
      comments as Comments,
      department as Department,
      userid as UserId,
      username as UserName,
      title as Title,
      divemplid as DivisionEmployeeId,
      divemplname as DivisionEmployeeName,
      businessarea as BusinessArea,
      divmanagerid as DivisionManagerId,
      divmanagername as DivisionManagerName,
      
      _Status,
      _GLRequest
}
