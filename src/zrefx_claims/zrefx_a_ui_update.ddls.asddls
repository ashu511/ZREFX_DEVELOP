@EndUserText.label: 'Parameters for UI Update'
define abstract entity ZREFX_A_UI_UPDATE
{
  
  MainDivision : abap.char(8); // Match your actual data element
  SubDivision  : abap.char(8);
  Legalflag    : abap_boolean;
  
}
