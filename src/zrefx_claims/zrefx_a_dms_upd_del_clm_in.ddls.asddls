@EndUserText.label: 'DMS Delete Input params'
define abstract entity ZREFX_A_DMS_UPD_DEL_CLM_IN 
{
//    id: abap.char(100);
//    documentid : abap.char(255);
//    objecttype: abap.char(100);
      claimid : abap.char(16);
  filename    : abap.char(255);
  mimetype    : abap.char(128);
  content     : zrefx_de_att; // Use the standard XSTRING data element for binary file data
}
