@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Land  Allocation'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define  view entity ZREFX_C_ROW_LAND_ALLOCATION 
as projection on    ZREFX_I_ROW_LAND_ALLOCATION
{
    key RequestId,
    LandNumber,
    LeaseInContract,
    LeaseOutContract,
    _LandRequest : redirected to parent ZREFX_C_ROW_REQUEST
}
