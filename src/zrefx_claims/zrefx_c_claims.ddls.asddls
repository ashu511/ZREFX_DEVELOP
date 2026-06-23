@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZREFX Claims Consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}

define root view entity ZREFX_C_CLAIMS
  provider contract transactional_query
  as projection on ZREFX_I_CLAIMS
{

  key Claimid,
      Createddate,
      Status,
      Vendorid,
      Vendorname,
      Vendorcompanyname,
      Contactpersonname,
      Contactmobile,
      Vendoraltnum,
      Vendorregistrationno,
      Contactemail,
      Legalflag,
//      Vendorcompanyname,
//      Contactpersonname,
//      Contactmobile,
//      Vendorregistrationno,
//      Contactemail,
//      Preferredlanguage,
      Claimcategory,
      Sourcechannel,
      Claimtype,
      Urgency,
      Referencetype,
      Referenceid,
      Contractnumber,
      Leasenumber,
      Projectid,
      Projectname,
      Claimreferenceno,
      Region,
      Claimsubject,
      Incidentdate,
      Requestedpaymentdate,
      Detaileddescription,
      Claimamount,
      Confirminformation,
      Consentdate,
      Lastchangedat,
      Locallastchangedat,
      _claimcat,
      _urgency,
      _Attachments: redirected to composition child ZREFX_C_ATT_CLAIMS
}
