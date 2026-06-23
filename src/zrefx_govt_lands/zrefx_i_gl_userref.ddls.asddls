@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for GL User Referance'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_GL_USERREF
  as select from zrefx_gl_userrf

{

  key userid       as UserID,
  key id           as Id,
      fullname     as FullName,
      email        as Email,
      division     as Division,
      organization as Organization,
      rolehint     as RoleHint,
      mobile       as Mobile
}
