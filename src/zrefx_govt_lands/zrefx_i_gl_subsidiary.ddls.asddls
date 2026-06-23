@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for GL Subsidiary'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_GL_SUBSIDIARY
  as select from zrefx_gl_subsid
  association [0..*] to ZREFX_I_GL_USERREF as _UserRef on $projection.DivisionManager = _UserRef.UserID

{

  key request_id      as RequestID,
  key code            as Code,
      name            as Name,
      _UserRef.UserID as DivisionManager,

      _UserRef
}
