@EndUserText.label: 'Copy BTP Configurations Data'
define abstract entity ZD_CopyROWConfigP
{
  @EndUserText.label: 'New Object Id'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: ObjectId' )
  ObjectId : ZREFX_DE_OBJECT_ID;
}
