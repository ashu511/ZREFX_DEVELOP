@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZREFX Complaints Consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}
define root view entity ZREFX_C_COMPLAINTS
  provider contract transactional_query
  as projection on ZREFX_I_COMPLAINTS
{
  key ComplaintId,
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
      //      @ObjectModel.text.element: [ 'Language' ]
      //      @UI.textArrangement: #TEXT_FIRST
      //      Preferredlanguage,
      //      Legalflag,
      Vendoraddress,
      @ObjectModel.text.element: [ 'ComplaintCatagiryDescription' ]
      @UI.textArrangement: #TEXT_FIRST
      Complaintcategory,
      Sourcechannel,
      Complainttype,
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_FIRST
      Urgency,
      Referencetype,
      Referenceid,
      Landid,
      Titledeedno,
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
      @ObjectModel.text.element: [ 'SubDivDescription' ]
      @UI.textArrangement: #TEXT_FIRST
      SubDivision,
      Subject,
      Incidentdate,
      Requestedoutcome,
      Detaileddescription,
      Financialimpact,
      Confirminformation,
      Consentdate,
      Createdby,
      Lastchangedat,
      Locallastchangedat,
      _urgency.Description  as Description,
      _compcat.Description  as ComplaintCatagiryDescription,
      //      _Language.LangText    as Language,
      _City.City            as CityDescription,
      _MainDiv.MainDIVISION as MainDivDescription,
      _SubDiv.SubDIVISION   as SubDivDescription,
      _compcat,
      _urgency,
      //      _Language,
      _City,
      _MainDiv,
      _SubDiv,
      _Attachments  : redirected to composition child ZREFX_C_ATT_COMPLAINTS,
      _WorkflowInfo : redirected to composition child ZREFX_C_WF_COM
}
