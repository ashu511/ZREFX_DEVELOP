@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Request Types'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_ROW_REQUESTTYPES_VH
  as select distinct from ZREFX_I_ROW_REQUEST
{
  key Requesttype  as RequestType
}
where
      Requesttype is not initial
  and Requesttype is not null
//where spras = $session.system_language
