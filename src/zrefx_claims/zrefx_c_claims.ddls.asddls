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
      @ObjectModel.text.element: [ 'StatusDescription' ]
      @UI.textArrangement: #TEXT_ONLY
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
      @ObjectModel.text.element: [ 'ClaimCategoryDescription' ]
      @UI.textArrangement: #TEXT_FIRST
      Claimcategory,
      Sourcechannel,
      Claimtype,
      Urgency,
      Referencetype,
      Referenceid,
      Landid,
      Contractnumber,
      Leasenumber,
      Projectid,
      Projectname,
      Claimreferenceno,
      Region,
      @ObjectModel.text.element: [ 'CityDescription' ]
      @UI.textArrangement: #TEXT_FIRST
      City,
      @ObjectModel.text.element: [ 'MainDivDescription' ]
      @UI.textArrangement: #TEXT_FIRST
      MainDivision,
      Titledeedno,
      Claimsubject,
      Incidentdate,
      Requestedpaymentdate,
      Detaileddescription,
      Claimamount,
      Confirminformation,
      Consentdate,
      RequestorEmail,
      CreatedBy,
      Lastchangedat,
      Locallastchangedat,
      _claimcat.Description as ClaimCategoryDescription,
      _Status.Description   as StatusDescription,
      _City.City            as CityDescription,
      _MainDiv.MainDIVISION as MainDivDescription,

      _claimcat,
      _urgency,
      _Status,
      _Attachments  : redirected to composition child ZREFX_C_ATT_CLAIMS,
      _WorkflowInfo : redirected to composition child ZREFX_C_WF_CLM
}
