@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZREFX Compensation Consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}
define root view entity ZREFX_C_COMPENSATION   provider contract transactional_query
  as projection on ZREFX_I_COMPENSATION
{
    key CompensationId,
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
    PaymentTerm,
    BudgetCheck,
    Compensationcategory,
    Sourcechannel,
    Compensationtype,
    Urgency,
    Referencetype,
    Referenceid,
    Landid,
    Contractnumber,
    Leasenumber,
    Projectid,
    Projectname,
    Compensationreferenceno,
    Region,
    City,
    OtherCity,
    MainDivision,
    Titledeedno,
     Compnssubject,
    Incidentdate,
    Requestedpaymentdate,
    Detaileddescription,
    Compensationamount,
    Confirminformation,
    Consentdate,
    RequestorEmail,
    CreatedBy,
    Lastchangedat,
    Locallastchangedat,
    /* Associations */
   
    _City,
    _claimcat,
    _MainDiv,
    _Status,
    _urgency,
     _Attachments :  redirected to composition child ZREFX_C_ATT_COMPNS,
    _WorkflowInfo : redirected to composition child ZREFX_C_WF_COMPNS
}
