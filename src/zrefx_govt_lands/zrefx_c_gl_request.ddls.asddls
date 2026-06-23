@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Land Request'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['RequestId']
define root view entity ZREFX_C_GL_REQUEST
  provider contract transactional_query
  as projection on ZREFX_I_GL_REQUEST
{
      @EndUserText.label: 'Request ID'
  key RequestId,

      @EndUserText.label: 'Request Date'
      Requestdate,

      @EndUserText.label: 'Request Type'
      Requesttype,

      @EndUserText.label: 'Request Description'
      Requestdescription,

      @EndUserText.label: 'Request Purpose'
      Requestpurpose,

      @EndUserText.label: 'Business Justification'
      Businessjustification,

      @EndUserText.label: 'Status Code'
      Statuscode,

      @EndUserText.label: 'Status'
      _Status._Text.Description as Status,

      @EndUserText.label: 'Current Step'
      Currentstep,

      @EndUserText.label: 'Current Step Changed At'
      Currentstepchangedat,

      @EndUserText.label: 'Approval Status Code'
      Approvalstatuscode,

      @EndUserText.label: 'Approval Status'
      Approvalstatus,

      @EndUserText.label: 'Current Processor Role'
      Currentprocessorrole,

      @EndUserText.label: 'Current Processor User'
      Currentprocessoruser,

      @EndUserText.label: 'Priority'
      Priority,

      @EndUserText.label: 'Source Subsidiary'
      Sourcesubsidiary,

      @EndUserText.label: 'Source Department'
      Sourcedepartment,

      @EndUserText.label: 'Requestor'
      Requestor,

      @EndUserText.label: 'Initiated By Role'
      Initiatedbyrole,

      @EndUserText.label: 'Previous Request Number'
      Previousrequestno,

      @EndUserText.label: 'Company Code'
      Companycode,

      @EndUserText.label: 'Business Area'
      Businessarea,

      @EndUserText.label: 'Profit Center'
      Profitcenter,

      @EndUserText.label: 'Cost Center'
      Costcenter,

      @EndUserText.label: 'Project Name (English)'
      Projectname,

      //      @EndUserText.label: 'Project Name (Arabic)'
      //      Projectname_A,

      @EndUserText.label: 'WBS Project Number'
      Wbsprojectno,

      @EndUserText.label: 'Stage Gate Project Number'
      Stagegateprojectno,

      @EndUserText.label: 'External Project Account Number'
      Externalprojectaccountno,

      @EndUserText.label: 'Project Budget Year'
      Projectbudgetyear,

      @EndUserText.label: 'Project Approval Year'
      Projectapprovalyear,

      @EndUserText.label: 'Project Cost (SAR)'
      Projectcostsar,

      @EndUserText.label: 'Project Start Date'
      Projectstartdate,

      @EndUserText.label: 'Project End Date'
      Projectenddate,

      @EndUserText.label: 'Hijri Start Date'
      Hijristartdate,

      @EndUserText.label: 'Hijri End Date'
      Hijrienddate,

      @EndUserText.label: 'Planned Completion Date'
      Plancompletiondate,

      @EndUserText.label: 'Actual Completion Date'
      Actualcompletiondate,

      @EndUserText.label: 'Station Type'
      Stationtype,

      @EndUserText.label: 'Voltage (kV)'
      Voltagekv,

      @EndUserText.label: 'Capacity (MVA)'
      Capacitymva,

      @EndUserText.label: 'Cable Length (km)'
      Cablelengthkm,

      @EndUserText.label: 'Facility Type'
      Facilitytype,

      @EndUserText.label: 'Land Category'
      Landcategory,

      @EndUserText.label: 'Requested Width (m)'
      Widthmrequested,

      @EndUserText.label: 'Requested Length (m)'
      Lengthmrequested,

      @EndUserText.label: 'Requested Area (sqm)'
      Areasqmrequested,

      @EndUserText.label: 'GIS Location Link'
      Gislocationlink,

      @EndUserText.label: 'GIS Project ID'
      Gisprojectid,

      @EndUserText.label: 'Requestor Comments'
      Requestorcomments,

      @EndUserText.label: 'Additional Comments'
      Additionalcomments,

      @EndUserText.label: 'Department'
      Department,

      @EndUserText.label: 'Title'
      Title,

      @EndUserText.label: 'User ID'
      Userid,

      @EndUserText.label: 'User Name'
      Username,

      @EndUserText.label: 'Current Step Description'
      CurrentStepDesc,

      @EndUserText.label: 'Current Processor Name'
      Currentprocessorname,

      @EndUserText.label: 'Current Processor Department'
      Currentprocessordepartment,

      @EndUserText.label: 'Milestone Description'
      MileStoneDescription,

      @EndUserText.label: 'Milestone'
      Milestone,

      Workflowinstanceid,
      MilestoneSequence,

            _Proposal           : redirected to composition child ZREFX_C_GL_PROPOSAL,
            _RequestAttachments : redirected to composition child ZREFX_C_GL_REQUEST_ATTACHMENT,
            _Clarifications     : redirected to composition child ZREFX_C_GL_CLARIFICATION,
            _LandAllocations    : redirected to composition child ZREFX_C_GL_LAND_ALLOCATION ,
            _WorkflowInstance   : redirected to composition child ZREFX_C_GL_WORKFLOW_INSTANCE,

      _StepMilestone,
      _ProcessorRole,
      // _UserRef,
      _StationType,
      _RequestType,
      _Status,
      _Subsidiary,
      _Workflow
}
