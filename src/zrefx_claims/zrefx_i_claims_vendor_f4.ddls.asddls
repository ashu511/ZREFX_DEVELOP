@EndUserText.label: 'Fetch Vendor Details from ECC'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_REFX_CLAIMS_VENDOR_F4'
define custom entity ZREFX_I_CLAIMS_VENDOR_F4
{

      @UI.lineItem         : [{ position: 10 }]
  key Vendorid             : abap.char( 10 );
      @UI.lineItem         : [{ position: 20 }]
      Vendorname           : abap.char( 80 );
      Vendorcompanyname    : abap.char( 80 );
      Contactpersonname    : abap.char( 80 );
      Contactmobile        : abap.char( 30 );
      //      Vendoraltnum         : abap.char( 30 );
      Vendorregistrationno : abap.char( 30 );
      Contactemail         : abap.char( 241 );
      //      Preferredlanguage    : abap.char( 2 );
      Vendoraddress        : abap.char( 150 );
}
