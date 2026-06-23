@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_LEASEIN_VH as select distinct from ZREFX_I_ROW_LAND_ALLOCATION
{
    @EndUserText.label: 'Land Number'
    @UI.hidden: true
    key LandNumber,
    @UI.hidden: true
    key RequestId,
    @EndUserText.label: 'Lease In Contract'
    LeaseInContract
    
}
where
      LeaseInContract is not initial
  and LeaseInContract is not null
