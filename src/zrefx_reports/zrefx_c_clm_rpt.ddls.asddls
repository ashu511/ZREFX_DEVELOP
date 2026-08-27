@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Claims Report Projection'
@Metadata.allowExtensions: true
define root view entity ZREFX_C_CLM_RPT
  as select from ZREFX_I_CLM_RPT
{
  key ClaimId,

      @ObjectModel.text.element: ['StatusDescription']
      @UI.textArrangement: #TEXT_ONLY
      Status,

      Createddate,
      Vendorid,
      Contactpersonname,
      Vendorregistrationno,
      Contactemail,
      Claimcategory,
      Sourcechannel,
      Claimtype,
      Urgency,
      Referencetype,
      Referenceid,
      Leasenumber,
      Projectid,
      Projectname,
      Claimreferenceno,
      Region,
      City,
      Claimsubject,
      Incidentdate,
      Requestedpaymentdate,
      Detaileddescription,
      Claimamount,

      @UI.hidden: true
      _Status.Description as StatusDescription


}
