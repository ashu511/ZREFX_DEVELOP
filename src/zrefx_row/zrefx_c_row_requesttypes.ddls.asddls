@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request Types'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_ROW_REQUESTTYPES as projection on ZREFX_I_ROW_REQUESTTYPES
{
    key Code,
        RequesttypeText
}
