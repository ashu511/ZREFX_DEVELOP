@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Clarification for GL Proposed'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_GL_CLARIFICATION as projection on ZREFX_I_GL_CLARIFICATION
{
    
     key Id,
     key RequestId,
  
      Statuscode,
      Raisedby,
      Question,
      Answeredby,
      Answer,

      /* Associations */
       _LandRequest : redirected to parent ZREFX_C_GL_REQUEST
      //_UserRef
}
