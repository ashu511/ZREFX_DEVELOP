@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_ALLOCATION_VH as select distinct from ZREFX_I_ROW_LAND_ALLOCATION
{
    @EndUserText.label: 'Land Number'
    key LandNumber,
    @UI.hidden: true
    key RequestId
    
}
where
      LandNumber is not initial
  and LandNumber is not null
