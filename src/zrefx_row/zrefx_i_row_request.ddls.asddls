@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request for ROW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
//@ObjectModel.semanticKey: ['RequestId']
define root view entity ZREFX_I_ROW_REQUEST
  as select from zrefx_row
  association [1..1] to ZREFX_I_ROW_STATIONTYPES      as _StationType   on  $projection.Stationtype = _StationType.Code
  association [1..1] to ZREFX_I_ROW_REQUESTTYPES      as _RequestType   on  $projection.Requesttype = _RequestType.Code
  association [0..1] to ZREFX_I_ROW_STATUS            as _Status        on  _Status.Statustype     = 'REQUEST'
                                                                        and $projection.Statuscode = _Status.Code
  association [1..1] to ZREFX_I_ROW_STEP_MILESTONE    as _StepMilestone on  $projection.Currentstep = _StepMilestone.Code

  association [1..1] to ZREFX_I_ROW_PROCESSOR_ROLE    as _ProcessorRole on  $projection.Currentprocessorrole = _ProcessorRole.Code

  association [0..1] to ZREFX_I_ROW_STEP_MILESTONE    as _Milestone     on  $projection.Milestone = _Milestone.Code
  association [1..1] to ZREFX_I_ROW_WORKFLOW_INSTANCE as _Workflow      on  _Workflow.Objecttype = 'REQUEST'


  association [0..*] to ZREFX_I_ROW_SUBSIDIARY       as _Subsidiary    on  $projection.RequestId = _Subsidiary.RequestID
  composition of many ZREFX_I_ROW_CLARIFICATION     as _Clarifications
  composition of many ZREFX_I_ROW_REQUEST_ATTACHMENT as _RequestAttachments
  composition of many ZREFX_I_ROW_PROPOSAL             as _Proposal
  composition of one ZREFX_I_ROW_LAND_ALLOCATION    as _LandAllocations
  composition of many ZREFX_I_ROW_WORKFLOW_INSTANCE   as _WorkflowInstance

{

  key request_id                 as RequestId,
      requestdate                as Requestdate,
      requesttype                as Requesttype,
      requestdescription         as Requestdescription,
      requestpurpose             as Requestpurpose,
      businessjustification      as Businessjustification,
      statuscode                 as Statuscode,
      _Status._Text.Description  as Status,
      //    status                     as Status,
      currentstep                as Currentstep,
      currentstepchangedat       as Currentstepchangedat,
      approvalstatuscode         as Approvalstatuscode,
      approvalstatus             as Approvalstatus,
      currentprocessorrole       as Currentprocessorrole,
      currentprocessoruser       as Currentprocessoruser,
      priority                   as Priority,
      sourcesubsidiary           as Sourcesubsidiary,
      sourcedepartment           as Sourcedepartment,
      requestor                  as Requestor,
      initiatedbyrole            as Initiatedbyrole,
      companycode                as Companycode,
      businessarea               as Businessarea,
      profitcenter               as Profitcenter,
      costcenter                 as Costcenter,
      projectname                as Projectname,
      projectname_a              as ProjectnameA,
      wbsprojectno               as Wbsprojectno,
      stagegateprojectno         as Stagegateprojectno,
      externalprojectaccountno   as Externalprojectaccountno,
      projectbudgetyear          as Projectbudgetyear,
      projectapprovalyear        as Projectapprovalyear,
      projectcostsar             as Projectcostsar,
      projectstartdate           as Projectstartdate,
      projectenddate             as Projectenddate,
      hijristartdate             as Hijristartdate,
      hijrienddate               as Hijrienddate,
      plancompletiondate         as Plancompletiondate,
      actualcompletiondate       as Actualcompletiondate,
      stationtype                as Stationtype,
      voltagekv                  as Voltagekv,
      capacitymva                as Capacitymva,
      cablelengthkm              as Cablelengthkm,
      facilitytype               as Facilitytype,
      landcategory               as Landcategory,
      widthmrequested            as Widthmrequested,
      lengthmrequested           as Lengthmrequested,
      areasqmrequested           as Areasqmrequested,
      gislocationlink            as Gislocationlink,
      gisprojectid               as Gisprojectid,
      previousrequestno          as Previousrequestno,
      requestorcomments          as Requestorcomments,
      additionalcomments         as Additionalcomments,
      department                 as Department,
      userid                     as Userid,
      username                   as Username,
      _StepMilestone.Description as CurrentStepDesc,
      title                      as Title,
      currentstepdescription     as Currentstepdescription,
      currentprocessorname       as Currentprocessorname,
      currentprocessordepartment as Currentprocessordepartment,
      milestone                  as Milestone,
      _Milestone.Description     as MileStoneDescription,
      //      milestonedesc              as Milestonedesc,
      workflowinstanceid         as Workflowinstanceid,
      //milestonesequence          as Milestonesequence,
      _Milestone.Sequence        as MilestoneSequence,



      _Workflow,

      _StepMilestone,
      _ProcessorRole,
      // _UserRef,
      _StationType,
      _RequestType,
      _Status,
      _RequestAttachments,
      _Proposal,

      _Milestone,
      _Subsidiary,
      _WorkflowInstance,
      _Clarifications,
      _LandAllocations
}
