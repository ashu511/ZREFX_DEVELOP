@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for SEC Configs'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_ROW_CONFIGS as select from zrefx_row_config
{
    key object_id as ObjectId,
    key environment as Environment,
    key config_value as ConfigValue,
    description as Description
}
