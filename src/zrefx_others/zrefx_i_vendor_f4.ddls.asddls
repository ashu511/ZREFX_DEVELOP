@EndUserText.label: 'Fetch Vendor Details from ECC'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_REFX_VENDOR_F4'
@Consumption.valueHelpDefault.fetchValues: #ON_EXPLICIT_REQUEST
define custom entity ZREFX_I_VENDOR_F4
{
      @UI.lineItem         : [{ position: 10 }]
      @UI.selectionField   : [{ position: 10 }]
  key Vendorid             : abap.char( 10 );

      @UI.lineItem         : [{ position: 20 }]
      @UI.selectionField   : [{ position: 20 }]
      Vendorname           : abap.char( 80 );

      @UI.lineItem         : [{ position: 30 }]
      @Consumption.filter.hidden: true
      Vendorcompanyname    : abap.char( 80 );

      @UI.lineItem         : [{ position: 40 }]
      @Consumption.filter.hidden: true
      Contactpersonname    : abap.char( 80 );

      @UI.lineItem         : [{ position: 50 }]
      @Consumption.filter.hidden: true
      Contactmobile        : abap.char( 30 );

      //      @Consumption.filter.hidden: true
      //      Vendoraltnum         : abap.char( 30 );

      @UI.lineItem         : [{ position: 60 }]
      @Consumption.filter.hidden: true
      Vendorregistrationno : abap.char( 30 );

      @UI.lineItem         : [{ position: 70 }]
      @Consumption.filter.hidden: true
      Contactemail         : abap.char( 241 );

      //      @Consumption.filter.hidden: true
      //      Preferredlanguage    : abap.char( 2 );

      @UI.lineItem         : [{ position: 80 }]
      @Consumption.filter.hidden: true
      Vendoraddress        : abap.char( 150 );
}
