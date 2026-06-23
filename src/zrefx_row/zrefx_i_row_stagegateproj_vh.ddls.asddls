@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stage Gate Project ID Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_STAGEGATEPROJ_VH
  as select distinct from ZREFX_I_ROW_REQUEST
{
  @EndUserText.label: 'Stage Gate Project ID'
  key Stagegateprojectno
}

where
      Stagegateprojectno is not initial
  and Stagegateprojectno is not null
