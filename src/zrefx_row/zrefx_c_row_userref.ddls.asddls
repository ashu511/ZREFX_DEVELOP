@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Referance'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_ROW_USERREF as projection on ZREFX_I_ROW_USERREF
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
