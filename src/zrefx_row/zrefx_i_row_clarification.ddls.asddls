@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for ROW Clarification'
@Metadata.ignorePropagatedAnnotations: true
define  view entity ZREFX_I_ROW_CLARIFICATION as select from zrefx_row_clarif
association        to parent ZREFX_I_ROW_REQUEST as _ROWRequest on $projection.RequestId = _ROWRequest.RequestId
{
    
    key id                     as Id,
     key request_id                 as RequestId,
   
      statuscode                 as Statuscode,
      raisedby          as Raisedby,
      question                   as Question,
      answeredby            as Answeredby,
      answer                     as Answer,
       title                     as Title,
      department                as Department,
      userid                    as UserId,
      username                  as UserName,

      _ROWRequest
    //  _UserRef
}
