@EndUserText.label: 'Copy Complaints App Configuration'
define abstract entity ZD_CopyComplaintsAppConfig
{
  @EndUserText.label: 'New Object Id'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: ObjectId' )
  ObjectId : ZREFX_DE_OBJECT_ID;
  @EndUserText.label: 'New Environment'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Environment' )
  Environment : ZREFX_DE_ENVIRONMENT;
}
