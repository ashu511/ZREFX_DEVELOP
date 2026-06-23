@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for ROW Request types'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_ROW_REQUESTTYPES as select distinct from zrefx_row_reqtyp

{
key code  as Code,
      text  as RequesttypeText
}
where
      code is not initial
  and code is not null
//where spras = $session.system_language
