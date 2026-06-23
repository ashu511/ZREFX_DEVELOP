@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Land  Allocation'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_LAND_ALLOCATION
  as select from zrefx_row_landal
  association to parent ZREFX_I_ROW_REQUEST as _LandRequest on $projection.RequestId = _LandRequest.RequestId
{

  key request_id       as RequestId,
      landnumber       as LandNumber,
      leaseincontract  as LeaseInContract,
      leaseoutcontract as LeaseOutContract,
      _LandRequest
}
