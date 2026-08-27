@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Complaints Report Root'
define root view entity ZREFX_I_COMP_RPT
  as select from zrefx_complaint
  association [0..1] to ZREFX_DOV_STATUS as _Status on  $projection.Status = _Status.Value
                                                    and _Status.language   = $session.system_language
{
  key complaint_id        as ComplaintId,
      @ObjectModel.text.association: '_Status'
      status              as Status,
      createddate         as Createddate,
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

      // Expose the association for the projection view
      _Status
}
