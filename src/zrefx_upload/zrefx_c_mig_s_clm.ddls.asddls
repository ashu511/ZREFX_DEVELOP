@EndUserText.label: 'Claims Staging Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZREFX_C_MIG_S_CLM
  as projection on ZREFX_I_MIG_S_CLM
{
  key ItemUuid,
      JobUuid,
      ClaimId,
      Createddate,
      Status,
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
      Claimcurrency,

      /* Associations */
      _Job : redirected to parent ZREFX_C_MIGRATION

}
