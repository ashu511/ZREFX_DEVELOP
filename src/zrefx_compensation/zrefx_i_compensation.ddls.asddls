@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interfasce view for Compensation'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_COMPENSATION
  as select from zrefx_compns
  composition [1..*] of ZREFX_I_ATT_COMPNS as _Attachments
  composition [0..*] of ZREFX_I_WF_COMPNS  as _WorkflowInfo
  association     to ZREFX_DOV_CLAIMCAT        as _claimcat on $projection.Compensationcategory = _claimcat.Value
  association     to ZREFX_DOV_URGENCY         as _urgency  on $projection.Urgency = _urgency.Value
  association [1] to ZREFX_DOV_CITY        as _City         on $projection.City = _City.Value
  association [1] to ZREFX_DOV_MAIN_DIV    as _MainDiv      on $projection.MainDivision = _MainDiv.Value
  association [1] to ZREFX_DOV_STATUS      as _Status       on $projection.Status = _Status.Value
{

  key compns_id            as CompensationId,
      createddate          as Createddate,
      @ObjectModel.text.association: '_Status'
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
      paymentterm          as PaymentTerm,
      budgetcheck          as BudgetCheck,
      @ObjectModel.text.association: '_claimcat'
      compnscategory       as Compensationcategory,
      sourcechannel        as Sourcechannel,
      compnstype           as Compensationtype,
      urgency              as Urgency,
      referencetype        as Referencetype,
      referenceid          as Referenceid,
      landid               as Landid,
      contractnumber       as Contractnumber,
      leasenumber          as Leasenumber,
      projectid            as Projectid,
      projectname          as Projectname,
      compnsreferenceno    as Compensationreferenceno,
      region               as Region,
      @ObjectModel.text.association: '_City'
      city                 as City,
      othercity            as OtherCity,
      //      @ObjectModel.text.association: '_MainDiv'
      maindivision         as MainDivision,
      //      @ObjectModel.text.association: '_SubDiv'
      titledeedno          as Titledeedno,
      compnssubject        as Compnssubject,
      incidentdate         as Incidentdate,
      requestedpaymentdate as Requestedpaymentdate,
      detaileddescription  as Detaileddescription,
      compnsamount         as Compensationamount,
      confirminformation   as Confirminformation,
      consentdate          as Consentdate,
      requestoremail       as RequestorEmail,
      @Semantics.user.createdBy: true
      createdby            as CreatedBy,
      lastchangedat        as Lastchangedat,
      locallastchangedat   as Locallastchangedat,
      _Attachments,
      _claimcat,
      _urgency,
      _WorkflowInfo,
      _City,
      _Status,
      _MainDiv
}
