@AbapCatalog.viewEnhancementCategory: [#NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Right of way report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}
@UI.headerInfo: {
    typeName: 'ROW Request',
    typeNamePlural: 'ROW Requests',
    title: { value: 'RequestId' },
    description: { value: 'Requestor' }
}
define view entity ZREFX_ROW_REPORT
  as select from ZREFX_I_ROW_REQUEST
{
  @EndUserText.label: 'Request  ID'
  @UI.lineItem: [{ position: 10 }]
   key RequestId,

  @EndUserText.label: 'Request  Date'
  @UI.lineItem: [{ position: 20 }]

  Requestdate,
  @EndUserText.label: 'Request  type'
  @UI.lineItem: [{ position: 30 }]

  Requesttype,

  @EndUserText.label: 'Status'
  @UI.lineItem: [{ position: 35 }]
  @UI.fieldGroup: [{ position: 35, qualifier: 'tqRequestDetails' }]

  Statuscode,
  @EndUserText.label: 'Request Description'
  @UI.lineItem: [{ position: 40 }]

  Requestdescription,
  @EndUserText.label: 'Request Purpose'
  @UI.lineItem: [{ position: 50 }]

  Requestpurpose,
  @EndUserText.label: 'Requestor Name'
  @UI.lineItem: [{ position: 60 }]

  Requestor,
  @EndUserText.label: 'Business Justification'
  @UI.lineItem: [{ position: 70 }]

  Businessjustification,
  @EndUserText.label: 'Previous Requestno'
  @UI.lineItem: [{ position: 80 }]

  Previousrequestno,
  @EndUserText.label: 'Requestor Comments'
  @UI.lineItem: [{ position: 90 }]

  Requestorcomments,
  @EndUserText.label: 'Additional Comments'
  @UI.lineItem: [{ position: 100 }]

  Additionalcomments,


  //Project Details
  @EndUserText.label: 'Wbs project No'
  @UI.lineItem: [{ position: 200 }]

  Wbsprojectno,
  @EndUserText.label: 'Stagegate Projectno'
  @UI.lineItem: [{ position: 210 }]

  Stagegateprojectno,
  @EndUserText.label: 'Project Start Date'
  @UI.lineItem: [{ position: 220 }]

  Projectstartdate,
  @EndUserText.label: 'Hijri Start Date'
  @UI.lineItem: [{ position: 230 }]

  Hijristartdate,
  @EndUserText.label: 'Plan Completion Date'
  @UI.lineItem: [{ position: 240 }]

  Plancompletiondate,
  @EndUserText.label: 'Project Budget Year'
  @UI.lineItem: [{ position: 250 }]

  Projectbudgetyear,
  @EndUserText.label: 'Volt age kv'
  @UI.lineItem: [{ position: 260 }]

  Voltagekv,
  @EndUserText.label: ' Project Name'
  @UI.lineItem: [{ position: 260 }]

  Projectname,
  @EndUserText.label: ' Project Arabic Name'
  @UI.lineItem: [{ position: 265 }]

  ProjectnameA,
  @EndUserText.label: 'Project Approval Year'
  @UI.lineItem: [{ position: 260 }]

  Projectapprovalyear,
  @EndUserText.label: 'Project End Date'
  @UI.lineItem: [{ position: 260 }]

  Projectenddate,
  @EndUserText.label: 'Hijri End Date'
  @UI.lineItem: [{ position: 260 }]

  Hijrienddate,
  @EndUserText.label: 'Actual Completion Date'
  @UI.lineItem: [{ position: 260 }]

  Actualcompletiondate,
  @EndUserText.label: 'Project Cost SAR'
  @UI.lineItem: [{ position: 260 }]

  Projectcostsar,

  @EndUserText.label: 'Estimated Project Cost SAR'
  @UI.lineItem: [{ position: 261 }]

  EstimatedProjectCost,

  //Ritght of way Requirement Details
  @EndUserText.label: 'Length'
  @UI.lineItem: [{ position: 300 }]

  Lengthmrequested,
  @EndUserText.label: 'Area'
  @UI.lineItem: [{ position: 310 }]

  Areasqmrequested,
  @EndUserText.label: 'Width'
  @UI.lineItem: [{ position: 320 }]

  Widthmrequested,



  //Geographic Location
  @EndUserText.label: 'City'
  @UI.lineItem: [{ position: 400 }]


  City,
  @EndUserText.label: 'Region'
  @UI.lineItem: [{ position: 410 }]

  Region,

  @EndUserText.label: 'GIS Id'
  @UI.lineItem: [{ position: 430 }]

  Gisprojectid,

  @EndUserText.label: 'Gis Link'
  @UI.lineItem: [{ position: 440 }]

  Gislocationlink,
  @EndUserText.label: 'Gis Drawing'
  @UI.lineItem: [{ position: 450 }]

  Gisdrawing,
  @EndUserText.label: 'Site area'
  @UI.lineItem: [{ position: 460 }]

  Sitearea,


  @EndUserText.label: 'Initiator Id'
  @UI.lineItem: [{ position: 500 }]

  Initiatorid,
  @EndUserText.label: 'Employee Number'
  @UI.lineItem: [{ position: 510 }]

  Employeenumber,
  @EndUserText.label: 'Initiator Full Name'
  @UI.lineItem: [{ position: 520 }]

  Initiatorfullname,
  @EndUserText.label: 'Initiator Organization'
  @UI.lineItem: [{ position: 530 }]

  Initiatororganization,
  @EndUserText.label: 'Email Address'
  @UI.lineItem: [{ position: 540 }]

  Emailaddress,
  @EndUserText.label: 'Contact Number'
  @UI.lineItem: [{ position: 550 }]

  Contactnumber,

  @EndUserText.label: 'Other City'
  @UI.lineItem: [{ position: 560 }]

  Othercity

}
