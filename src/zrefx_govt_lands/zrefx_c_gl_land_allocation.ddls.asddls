@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Land  Allocation'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define  view entity ZREFX_C_GL_LAND_ALLOCATION 
as projection on    ZREFX_I_GL_LAND_ALLOCATION
{
    key RequestId,
    LandNumber,
    LeaseInContract,
    LeaseOutContract,
    _LandRequest : redirected to parent ZREFX_C_GL_REQUEST
}
