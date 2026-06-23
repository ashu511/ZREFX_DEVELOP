@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Milestones'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_GL_STEP_MILESTONE 
as projection on ZREFX_I_GL_STEP_MILESTONE
{
  key Code,
  key Id,
      Description,
      Sequence,
      Active
    
}
