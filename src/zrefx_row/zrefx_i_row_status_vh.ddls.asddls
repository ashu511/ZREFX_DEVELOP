@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_STATUS_VH
  as select from zrefx_row_status as s
  association [1..1] to ZREFX_I_ROW_STATUS_TEXT as _Text on  s.code         = _Text.StatusCode
                                                         and _Text.Language = $session.system_language
{
  key _Text.Description as StatusDescription,
      @UI.hidden: true
      s.code            as StatusCode

}
where
      s.code       <> 'DRAFT'
  and s.code       <> 'SUBMITTED'
  and s.statustype =  'REQUEST';
