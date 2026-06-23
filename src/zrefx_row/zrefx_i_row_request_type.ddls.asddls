@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_REQUEST_TYPE as select distinct from ZREFX_I_ROW_REQUEST
{
    @EndUserText.label: 'Request Type'
    key Requesttype
}
