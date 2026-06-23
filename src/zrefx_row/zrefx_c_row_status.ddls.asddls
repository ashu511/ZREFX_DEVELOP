@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Statuses'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_ROW_STATUS as projection on ZREFX_I_ROW_STATUS
{
    key Id,
    key Statustype,
    key Code,
    Sequence,
    Active,
    _Text
}
