@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Land Request Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_LANDREQUEST_VH
  as select distinct from ZREFX_I_ROW_REQUEST
{
  @EndUserText.label: 'Request No'
  key RequestId
}

where
      RequestId is not initial
  and RequestId is not null and Statuscode <> 'DRAFT'
