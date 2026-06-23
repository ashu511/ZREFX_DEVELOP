@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for GL Station Types'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_GL_STATIONTYPES
  as select from zrefx_gl_stypes

{
  key code as Code,
  key id   as Id,
      text as Text
}
