@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Text'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_ROW_STATUS_TEXT
  as select from zrefx_row_stat_t

{
      @ObjectModel.text.element: ['Description']
  key statusid    as StatusId,
      @Semantics.language: true
  key language    as Language,
  key statuscode  as StatusCode,
      @Semantics.text: true

      description as Description

}
