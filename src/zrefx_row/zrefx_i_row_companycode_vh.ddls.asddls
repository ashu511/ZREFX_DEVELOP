@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request Company Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_COMPANYCODE_VH
  as select distinct from ZREFX_I_ROW_REQUEST
{
  @EndUserText.label: 'Request Company'
  key Companycode
}
where
      Companycode is not initial
  and Companycode is not null
