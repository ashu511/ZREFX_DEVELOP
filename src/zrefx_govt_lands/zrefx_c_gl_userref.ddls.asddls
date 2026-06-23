@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Referance'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_GL_USERREF 
as projection on ZREFX_I_GL_USERREF
{
  key UserID,
  key Id,
      FullName,
      Email,
      Division,
      Organization,
      RoleHint,
      Mobile

}
