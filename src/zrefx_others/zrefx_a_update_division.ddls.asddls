@EndUserText.label: 'Parameters for Division Update'
define abstract entity ZREFX_A_UPDATE_DIVISION
{
  MainDivision : abap.char(8); // Match your actual data element
  SubDivision  : abap.char(8);
  Legalflag    : abap_boolean;
}
