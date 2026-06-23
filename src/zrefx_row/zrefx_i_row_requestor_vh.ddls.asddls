@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Requestor Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_REQUESTOR_VH
  as select distinct from ZREFX_I_ROW_REQUEST
{
  @EndUserText.label: 'Requestor'
  key Requestor
}

where
      Requestor is not initial
  and Requestor is not null
