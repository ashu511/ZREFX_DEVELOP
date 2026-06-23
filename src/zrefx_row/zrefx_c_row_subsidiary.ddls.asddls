@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Subsidiary'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_ROW_SUBSIDIARY as select from ZREFX_I_ROW_SUBSIDIARY
{
     key RequestID,
      Code,
      Name,
      DivisionManager,

      _UserRef
}
