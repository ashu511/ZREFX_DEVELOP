@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Complaints Report Projection'
@Metadata.allowExtensions: true
define root view entity ZREFX_C_COMP_RPT
  as select from ZREFX_I_COMP_RPT
{
  key ComplaintId,

      @ObjectModel.text.element: ['StatusDescription']
      Status,

      Createddate,
      Vendorid,
      Vendorcompanyname,
      Contactpersonname,
      Contactmobile,
      Contactemail,
      Legalflag,
      Complaintcategory,
      Sourcechannel,
      Complainttype,
      Urgency,
      Referencetype,
      Referenceid,
      Landid,
      Titledeedno,
      Projectid,
      Claimreferenceno,
      Region,
      Detaileddescription,
      Financialimpact,

      @UI.hidden: true
      _Status.Description as StatusDescription

}
