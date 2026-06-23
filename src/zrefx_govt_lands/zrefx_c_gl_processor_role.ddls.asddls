@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Processor Roles'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_GL_PROCESSOR_ROLE
  as projection on ZREFX_I_GL_PROCESSOR_ROLE
{
  key Id,
  key Code,
      Description,
      Sequence,
      Active

}
