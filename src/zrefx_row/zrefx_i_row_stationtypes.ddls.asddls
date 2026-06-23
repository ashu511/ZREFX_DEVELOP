@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for ROW Station Types'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_ROW_STATIONTYPES
  as select from zrefx_row_stypes

{
  key code as Code,
  key id   as Id,
      text as Text
}
