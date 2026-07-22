@EndUserText.label: 'Complaints Staging Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZREFX_C_MIG_S_COMP
  as projection on ZREFX_I_MIG_S_COMP
{
  key ItemUuid,
      JobUuid,
      ComplaintId,
      Createddate,
      Status,
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

      /* Associations */
      _Job : redirected to parent ZREFX_C_MIGRATION

}
