@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Subsidiary'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_GL_SUBSIDIARY 
as select from ZREFX_I_GL_SUBSIDIARY
{
     key RequestID,
      Code,
      Name,
      DivisionManager,

      _UserRef
}
