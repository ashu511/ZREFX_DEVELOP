@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for SEC Configs'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_GL_CONFIGS 
as select from zrefx_gl_config
{
    key object_id as ObjectId,
    key environment as Environment,
    key config_value as ConfigValue,
    description as Description
}
