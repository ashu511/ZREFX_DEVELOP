@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for GL Step Milestone'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_GL_STEP_MILESTONE
  as select from zrefx_gl_stp_ms
{

  key code        as Code,
  key id          as Id,
      description as Description,
      sequence    as Sequence,
      active      as Active
}
