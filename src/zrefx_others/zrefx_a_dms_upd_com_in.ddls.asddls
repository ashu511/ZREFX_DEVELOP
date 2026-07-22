@EndUserText.label: 'DMS Upload Input'
define root abstract entity ZREFX_A_DMS_UPD_COM_IN
{
  complaintid : abap.char(16);
  filename    : abap.char(255);
  mimetype    : abap.char(128);
  content     : zrefx_de_att; // Use the standard XSTRING data element for binary file data
}
