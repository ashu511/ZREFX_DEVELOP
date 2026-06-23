@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for ROW Status'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_ROW_STATUS as select from zrefx_row_status
 association [1..1] to ZREFX_I_ROW_STATUS_TEXT as _Text on $projection.Code = _Text.StatusCode and _Text.Language = $session.system_language
{
    
     @UI.textArrangement: #TEXT_FIRST
      // @ObjectModel.text.association: '_Text'
  key id         as Id,
  key statustype as Statustype,
  key code       as Code,

      sequence   as Sequence,
      active     as Active,
      _Text
}
