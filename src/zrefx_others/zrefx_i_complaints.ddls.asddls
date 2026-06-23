@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZREFX Complaints Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}
@ObjectModel.dataCategory: #TEXT
define root view entity ZREFX_I_COMPLAINTS
  as select from zrefx_complaints
  composition [1..*] of ZREFX_I_ATT_COMPlAINTS as _Attachments
  composition [0..*] of ZREFX_I_WF_COM         as _WorkflowInfo
  association     to ZREFX_DOV_COMPCAT             as _compcat on $projection.Complaintcategory = _compcat.Value
  association [1] to ZREFX_DOV_URGENCY         as _urgency     on $projection.Urgency = _urgency.Value
  //  association [1] to ZREFX_DOV_LANGU           as _Language    on $projection.preferredlanguage = _Language.Value
  association [1] to ZREFX_DOV_CITY            as _City        on $projection.City = _City.Value
  association [1] to ZREFX_DOV_MAIN_DIV        as _MainDiv     on $projection.MainDivision = _MainDiv.Value
  association [1] to ZREFX_DOV_SUB_DIV         as _SubDiv      on $projection.SubDivision = _SubDiv.Value
{
  key complaint_id         as ComplaintId,
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
      //      @ObjectModel.text.association: '_Language'
      //      preferredlanguage    as Preferredlanguage,
      //      legalflag            as Legalflag,
      vendoraddress        as Vendoraddress,
      @ObjectModel.text.association: '_compcat'
      complaintcategory    as Complaintcategory,
      sourcechannel        as Sourcechannel,
      complainttype        as Complainttype,
      @ObjectModel.text.association: '_urgency'
      urgency              as Urgency,
      referencetype        as Referencetype,
      referenceid          as Referenceid,
      landid               as Landid,
      titledeedno          as Titledeedno,
      projectid            as Projectid,
      projectname          as Projectname,
      claimreferenceno     as Claimreferenceno,
      region               as Region,
      @ObjectModel.text.association: '_City'
      city                 as City,
      //      @ObjectModel.text.association: '_MainDiv'
      maindivision         as MainDivision,
      //      @ObjectModel.text.association: '_SubDiv'
      subdivision          as SubDivision,
      subject              as Subject,
      incidentdate         as Incidentdate,
      requestedoutcome     as Requestedoutcome,
      detaileddescription  as Detaileddescription,
      financialimpact      as Financialimpact,
      confirminformation   as Confirminformation,
      consentdate          as Consentdate,
      @Semantics.user.createdBy: true
      createdby            as Createdby,
      lastchangedat        as Lastchangedat,
      locallastchangedat   as Locallastchangedat,
      // _urgency.Description as Description,
      _compcat,
      _urgency,
      //      _Language,
      _City,
      _MainDiv,
      _SubDiv,
      _Attachments,
      _WorkflowInfo
}
