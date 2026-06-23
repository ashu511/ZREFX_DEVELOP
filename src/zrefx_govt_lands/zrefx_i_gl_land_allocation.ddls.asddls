@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Land  Allocation'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_GL_LAND_ALLOCATION
  as select from zrefx_gl_landal
  association to parent ZREFX_I_GL_REQUEST as _LandRequest on $projection.RequestId = _LandRequest.RequestId
{

  key request_id       as RequestId,
      landnumber       as LandNumber,
      leaseincontract  as LeaseInContract,
      leaseoutcontract as LeaseOutContract,
      _LandRequest
}
