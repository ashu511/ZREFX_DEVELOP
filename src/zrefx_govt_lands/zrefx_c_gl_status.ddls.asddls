@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Statuses'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_GL_STATUS as projection on ZREFX_I_GL_STATUS
{
    key Id,
    key Statustype,
    key Code,
    Sequence,
    Active,
    _Text
}
