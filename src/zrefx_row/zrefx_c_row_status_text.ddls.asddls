@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Text'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_ROW_STATUS_TEXT  as projection on ZREFX_I_ROW_STATUS_TEXT
{
  
    key StatusId,
    @Semantics.language: true
    key Language,
    key StatusCode,
    Description
}
