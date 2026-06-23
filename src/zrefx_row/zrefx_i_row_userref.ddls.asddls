@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for ROW User Referance'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_ROW_USERREF
  as select from zrefx_row_userrf

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
