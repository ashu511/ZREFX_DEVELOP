@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for StationTypes'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_ROW_STATIONTYPES as projection on ZREFX_I_ROW_STATIONTYPES
{
    key Code,
    key Id,
    Text
}
