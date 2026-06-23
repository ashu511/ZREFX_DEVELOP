@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Land No Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_LANDNO_VH
  as select distinct from ZREFX_I_ROW_PROPOSEDLAND
{
  @EndUserText.label: 'Land No'
  key Landid
}
