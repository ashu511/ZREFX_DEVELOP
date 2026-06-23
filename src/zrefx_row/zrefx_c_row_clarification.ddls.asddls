@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Clarification for ROW Proposed'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_ROW_CLARIFICATION as projection on ZREFX_I_ROW_CLARIFICATION
{
    
     key Id,
     key RequestId,
   
      Statuscode,
      Raisedby,
      Question,
      Answeredby,
      Answer,

      /* Associations */
       _ROWRequest : redirected to parent ZREFX_C_ROW_REQUEST
      //_UserRef
}
