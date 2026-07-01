@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZREFX Claims Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}

define root view entity ZREFX_I_CLAIMS
  as select from zrefx_claims
  composition [1..*] of ZREFX_I_ATT_CLAIMS as _Attachments
  composition [0..*] of ZREFX_I_WF_CLM     as _WorkflowInfo
  association     to ZREFX_DOV_CLAIMCAT        as _claimcat on $projection.Claimcategory = _claimcat.Value
  association     to ZREFX_DOV_URGENCY         as _urgency  on $projection.Urgency = _urgency.Value
  association [1] to ZREFX_DOV_CITY        as _City         on $projection.City = _City.Value
  association [1] to ZREFX_DOV_MAIN_DIV    as _MainDiv      on $projection.MainDivision = _MainDiv.Value

{

  key claim_id             as Claimid,
      createddate          as Createddate,
      status               as Status,
      vendorid             as Vendorid,
      vendorname           as Vendorname,
      vendorcompanyname    as Vendorcompanyname,
      contactpersonname    as Contactpersonname,
      contactmobile        as Contactmobile,
      vendoraltnum         as Vendoraltnum,
      vendorregistrationno as Vendorregistrationno,
      contactemail         as Contactemail,
      legalflag            as Legalflag,
      claimcategory        as Claimcategory,
      sourcechannel        as Sourcechannel,
      claimtype            as Claimtype,
      urgency              as Urgency,
      referencetype        as Referencetype,
      referenceid          as Referenceid,
        landid             as landid,
      contractnumber       as Contractnumber,
      leasenumber          as Leasenumber,
      projectid            as Projectid,
      projectname          as Projectname,
      claimreferenceno     as Claimreferenceno,
      region               as Region,
      @ObjectModel.text.association: '_City'
      city                 as City,
      //      @ObjectModel.text.association: '_MainDiv'
      maindivision         as MainDivision,
      //      @ObjectModel.text.association: '_SubDiv'
      titledeedno       as Titledeedno,
      claimsubject         as Claimsubject,
      incidentdate         as Incidentdate,
      requestedpaymentdate as Requestedpaymentdate,
      detaileddescription  as Detaileddescription,
      claimamount          as Claimamount,
      confirminformation   as Confirminformation,
      consentdate          as Consentdate,
      createdby            as CreatedBy,
      lastchangedat        as Lastchangedat,
      locallastchangedat   as Locallastchangedat,
      _Attachments,
      _claimcat,
      _urgency,
      _WorkflowInfo,
      _City,
      _MainDiv

}
