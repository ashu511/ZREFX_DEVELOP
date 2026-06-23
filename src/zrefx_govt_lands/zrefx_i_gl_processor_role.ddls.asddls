@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for GL Processor Role'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_GL_PROCESSOR_ROLE
  as select from zrefx_gl_pro_ro

{

  key id          as Id,
  key code        as Code,
      description as Description,
      sequence    as Sequence,
      active      as Active
}
