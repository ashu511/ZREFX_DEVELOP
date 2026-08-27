@AbapCatalog.viewEnhancementCategory: [#NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Report for GOV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}
@UI.headerInfo: {
    typeName: 'GOV Request',
    typeNamePlural: 'GOV Requests',
    title: { value: 'RequestId' },
    description: { value: 'Requestor' }
}
define view entity ZREFX_GOV_REPORT
  as select from ZREFX_I_GL_REQUEST
{
      @EndUserText.label: 'Request ID'
      @UI.lineItem: [{ position: 10 }]
  key RequestId,
      @EndUserText.label: 'Request Date'
      @UI.lineItem: [{ position: 20 }]
      Requestdate,
      @EndUserText.label: 'Request Type'
      @UI.lineItem: [{ position: 30 }]
      Requesttype,
      @EndUserText.label: 'Request Description'
      @UI.lineItem: [{ position: 40 }]
      Requestdescription,
      @EndUserText.label: 'Request Purpose'
      @UI.lineItem: [{ position: 50 }]
      Requestpurpose,
      @EndUserText.label: 'Business Justification'
      @UI.lineItem: [{ position: 60 }]
      Businessjustification,
      @EndUserText.label: 'Status Code'
      @UI.lineItem: [{ position: 70 }]
      Statuscode,
//      @EndUserText.label: 'Status'
//      @UI.lineItem: [{ position: 80 }]
//      Status,
      @EndUserText.label: 'Current Step'
      @UI.lineItem: [{ position: 90 }]
      Currentstep,
      @EndUserText.label: 'Current Step Changed At'
      @UI.lineItem: [{ position: 100 }]
      Currentstepchangedat,
      @EndUserText.label: 'Approval Status Code'
      @UI.lineItem: [{ position: 110 }]
      Approvalstatuscode,
      @EndUserText.label: 'Approval Status'
      @UI.lineItem: [{ position: 120 }]
      Approvalstatus,
      @EndUserText.label: 'Current Processor Role'
      @UI.lineItem: [{ position: 130 }]
      Currentprocessorrole,
      @EndUserText.label: 'Current Processor User'
      @UI.lineItem: [{ position: 140 }]
      Currentprocessoruser,
      @EndUserText.label: 'Priority'
      @UI.lineItem: [{ position: 150 }]
      Priority,
      @EndUserText.label: 'Source Subsidiary'
      @UI.lineItem: [{ position: 160 }]
      Sourcesubsidiary,
      @EndUserText.label: 'Source Department'
      @UI.lineItem: [{ position: 710 }]
      Sourcedepartment,
      @EndUserText.label: 'Requestor'
      @UI.lineItem: [{ position: 180 }]
      Requestor,
      @EndUserText.label: 'Initiated By Role'
      @UI.lineItem: [{ position: 190 }]
      Initiatedbyrole,
      @EndUserText.label: 'Company Code'
      @UI.lineItem: [{ position: 100 }]
      Companycode,
      @EndUserText.label: 'Business Area'
      @UI.lineItem: [{ position: 200 }]
      Businessarea,
      @EndUserText.label: 'Profit Center'
      @UI.lineItem: [{ position: 210 }]
      Profitcenter,
      @EndUserText.label: 'Cost Center'
      @UI.lineItem: [{ position: 220 }]
      Costcenter,
      @EndUserText.label: 'Project Name'
      @UI.lineItem: [{ position: 230 }]
      Projectname,
      @EndUserText.label: 'Project Name A'
      @UI.lineItem: [{ position: 240 }]
      ProjectnameA,
      @EndUserText.label: 'WBS Project Number'
      @UI.lineItem: [{ position: 250 }]
      Wbsprojectno,
      @EndUserText.label: 'Stage Gate Project Number'
      @UI.lineItem: [{ position: 260 }]
      Stagegateprojectno,
      @EndUserText.label: 'External Project Account Number'
      @UI.lineItem: [{ position: 270 }]
      Externalprojectaccountno,
      @EndUserText.label: 'Project Budget Year'
      @UI.lineItem: [{ position: 280 }]
      Projectbudgetyear,
      @EndUserText.label: 'Project Approval Year'
      @UI.lineItem: [{ position: 290 }]
      Projectapprovalyear,
      @EndUserText.label: 'Project Costs SAR'
      @UI.lineItem: [{ position: 300 }]

      Projectcostsar,
      @EndUserText.label: 'Project Start Date'
      @UI.lineItem: [{ position: 310 }]
      Projectstartdate,
      @EndUserText.label: 'Project End Date'
      @UI.lineItem: [{ position: 320 }]
      Projectenddate,
      @EndUserText.label: 'Hijri Start Date'
      @UI.lineItem: [{ position: 330 }]
      Hijristartdate,
      @EndUserText.label: 'Hijri End Date'
      @UI.lineItem: [{ position: 340 }]
      Hijrienddate,
      @EndUserText.label: 'Plan Completion Date'
      @UI.lineItem: [{ position: 350 }]
      Plancompletiondate,
      @EndUserText.label: 'Actual Completion Date'
      @UI.lineItem: [{ position: 360 }]
      Actualcompletiondate,
      @EndUserText.label: 'Station Type'
      @UI.lineItem: [{ position: 370 }]
      Stationtype,
      @EndUserText.label: 'Voltage (kV)'
      @UI.lineItem: [{ position: 380 }]
      Voltagekv,
      @EndUserText.label: 'Capacity (MVA)'
      @UI.lineItem: [{ position: 390 }]

      Capacitymva,
      @EndUserText.label: 'Cable Length (km)'
      @UI.lineItem: [{ position: 400 }]
      Cablelengthkm,
      @EndUserText.label: 'Facility Type'
      @UI.lineItem: [{ position: 410 }]
      Facilitytype,
      @EndUserText.label: 'Land Category'
      @UI.lineItem: [{ position: 420 }]
      Landcategory,
      @EndUserText.label: 'Width (m) Requested'
      @UI.lineItem: [{ position: 430 }]
      Widthmrequested,
      @EndUserText.label: 'Length (m) Requested'
      @UI.lineItem: [{ position: 440 }]
      Lengthmrequested,
      @EndUserText.label: 'Area (sq.m) Requested'
      @UI.lineItem: [{ position: 450 }]
      Areasqmrequested,
      @EndUserText.label: 'GIS Location Link'
      @UI.lineItem: [{ position: 460 }]
      Gislocationlink,
      @EndUserText.label: 'GIS Project ID'
      @UI.lineItem: [{ position: 470 }]
      Gisprojectid,
      @EndUserText.label: 'Previous Request Number'
      @UI.lineItem: [{ position: 480 }]
      Previousrequestno,
      @EndUserText.label: 'Requestor Comments'
      @UI.lineItem: [{ position: 490 }]
      Requestorcomments,
      @EndUserText.label: 'Additional Comments'
      @UI.lineItem: [{ position: 500 }]
      Additionalcomments,
      @EndUserText.label: 'Department'
      @UI.lineItem: [{ position: 560 }]
      Department,
      @EndUserText.label: 'User ID'
      @UI.lineItem: [{ position: 570 }]
      Userid,
      @EndUserText.label: 'User Name'
      @UI.lineItem: [{ position: 580 }]
      Username,
      //        @EndUserText.label: 'Current Step Description'
      //  @UI.lineItem: [{ position: 590 }]
      //      CurrentStepDesc,
      @EndUserText.label: 'Title'
      @UI.lineItem: [{ position: 600 }]
      Title,
      @EndUserText.label: 'Current Step Description'
      @UI.lineItem: [{ position: 610 }]
      Currentstepdescription,
      @EndUserText.label: 'Current Processor Name'
      @UI.lineItem: [{ position: 620 }]
      Currentprocessorname,
      @EndUserText.label: 'Current Processor Department'
      @UI.lineItem: [{ position: 630 }]
      Currentprocessordepartment,
      @EndUserText.label: 'Milestone'
      @UI.lineItem: [{ position: 640 }]
      Milestone,
      //        @EndUserText.label: 'Milestone Description'
      //  @UI.lineItem: [{ position: 650 }]
      //      MileStoneDescription,
      @EndUserText.label: 'Workflow Instance ID'
      @UI.lineItem: [{ position: 670 }]
      Workflowinstanceid
      //        @EndUserText.label: 'Milestone Sequence'
      //  @UI.lineItem: [{ position: 680 }]
      //      MilestoneSequence
}
