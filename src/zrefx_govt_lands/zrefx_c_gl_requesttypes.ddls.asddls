@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request Types'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_C_GL_REQUESTTYPES 
as projection on ZREFX_I_GL_REQUESTTYPES
{
    key Code,
        RequesttypeText
}
