@EndUserText.label: 'DMS Upload Input'
define root abstract entity ZREFX_A_DMS_UPD_COM_IN
{
  content       : zrefx_de_att;
  filename      : abap.char(255);
  mediatype     : abap.char(100);
  request_id    : abap.char(10);
  requestnumber : abap.char(30);
  documenttype  : abap.char(40);
  documentname  : abap.char(255);
  category      : abap.char(40);
  notes         : abap.char(255);
  created_by    : abap.char(100);
  created_at    : abap.utclong;
}
