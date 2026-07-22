@EndUserText.label: 'Parameters for Division Update'
define abstract entity ZREFX_A_UPDATE_DIVISION
{
  ComplaintId        : abap.char(16);
  MainDivision       : abap.char(8); // Match your actual data element
  //  SubDivision  : abap.char(8);
  MainDivDescription : abap.char(60);
  Legalflag          : abap_boolean;
}
