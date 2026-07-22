@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Claims Staging Item'
@Metadata.allowExtensions: true
define view entity ZREFX_I_MIG_S_CLM
  as select from zrefx_mig_s_clm
  association to parent ZREFX_I_MIGRATION as _Job on $projection.JobUuid = _Job.JobUuid
{
  key item_uuid            as ItemUuid,
      job_uuid             as JobUuid,
      claim_id             as ClaimId,
      createddate          as Createddate,
      status               as Status,
      vendorid             as Vendorid,
      contactpersonname    as Contactpersonname,
      vendorregistrationno as Vendorregistrationno,
      contactemail         as Contactemail,
      claimcategory        as Claimcategory,
      sourcechannel        as Sourcechannel,
      claimtype            as Claimtype,
      urgency              as Urgency,
      referencetype        as Referencetype,
      referenceid          as Referenceid,
      leasenumber          as Leasenumber,
      projectid            as Projectid,
      projectname          as Projectname,
      claimreferenceno     as Claimreferenceno,
      region               as Region,
      city                 as City,
      claimsubject         as Claimsubject,
      incidentdate         as Incidentdate,
      requestedpaymentdate as Requestedpaymentdate,
      detaileddescription  as Detaileddescription,
      claimamount          as Claimamount,
      claimcurrency        as Claimcurrency,

      _Job
}
