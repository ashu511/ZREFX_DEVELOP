@EndUserText.label: 'Parameters for UI Update'
define abstract entity ZREFX_A_UI_UPDATE
{
  Claim_id     : abap.char(16);
  MainDivision : abap.char(8); // Match your actual data element
  SubDivision  : abap.char(8);
  Legalflag    : abap_boolean;
  PaymentTerm : abap_boolean;
  BudgetCheck  : abap_boolean;


}
