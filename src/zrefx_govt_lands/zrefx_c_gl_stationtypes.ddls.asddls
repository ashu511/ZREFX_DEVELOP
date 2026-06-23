@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for StationTypes'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_GL_STATIONTYPES 
as projection on ZREFX_I_GL_STATIONTYPES
{
    key Code,
    key Id,
    Text
}
