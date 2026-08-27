@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Claims Report Root'
define root view entity ZREFX_I_CLM_RPT
  as select from zrefx_claims

  association [0..1] to ZREFX_DOV_STATUS as _Status on  $projection.Status = _Status.Value
                                                    and _Status.language   = $session.system_language
{
  key claim_id             as ClaimId,

      @ObjectModel.text.association: '_Status'
      status               as Status,

      createddate          as Createddate,
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

      _Status


}
