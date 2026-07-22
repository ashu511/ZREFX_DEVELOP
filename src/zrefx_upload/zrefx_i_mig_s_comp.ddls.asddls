@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Complaints Staging Item'
@Metadata.allowExtensions: true
define view entity ZREFX_I_MIG_S_COMP
  as select from zrefx_mig_s_comp
  association to parent ZREFX_I_MIGRATION as _Job on $projection.JobUuid = _Job.JobUuid
{
  key item_uuid           as ItemUuid,
      job_uuid            as JobUuid,
      complaint_id        as ComplaintId,
      createddate         as Createddate,
      status              as Status,
      vendorid            as Vendorid,
      vendorcompanyname   as Vendorcompanyname,
      contactpersonname   as Contactpersonname,
      contactmobile       as Contactmobile,
      contactemail        as Contactemail,
      legalflag           as Legalflag,
      complaintcategory   as Complaintcategory,
      sourcechannel       as Sourcechannel,
      complainttype       as Complainttype,
      urgency             as Urgency,
      referencetype       as Referencetype,
      referenceid         as Referenceid,
      landid              as Landid,
      titledeedno         as Titledeedno,
      projectid           as Projectid,
      claimreferenceno    as Claimreferenceno,
      region              as Region,
      detaileddescription as Detaileddescription,
      financialimpact     as Financialimpact,

      _Job
}
