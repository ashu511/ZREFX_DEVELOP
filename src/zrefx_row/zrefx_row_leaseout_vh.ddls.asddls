@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_ROW_LEASEOUT_VH as select distinct from ZREFX_I_ROW_LAND_ALLOCATION
{
    @EndUserText.label: 'Land Number'
    @UI.hidden: true
    key LandNumber,
    @UI.hidden: true
    key RequestId,
    @EndUserText.label: 'Lease Out Contract'
    LeaseOutContract
    
}
where
      LeaseOutContract is not initial
  and LeaseOutContract is not null

