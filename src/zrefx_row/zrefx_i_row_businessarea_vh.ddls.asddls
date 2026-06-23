@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Area Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_BUSINESSAREA_VH
  as select distinct from ZREFX_I_ROW_REQUEST
{
  @EndUserText.label: 'Business Area'
  key Businessarea
}
where
      Businessarea is not initial
  and Businessarea is not null and Statuscode <> 'DRAFT'
