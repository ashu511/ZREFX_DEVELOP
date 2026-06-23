@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for SEC configs'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZREFX_C_GL_CONFIGS 
as projection on ZREFX_I_GL_CONFIGS
{
    key ObjectId,
    key Environment,
    key ConfigValue,
    Description
}

