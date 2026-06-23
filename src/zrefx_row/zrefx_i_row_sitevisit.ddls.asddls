@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Site Visit'
@Metadata.ignorePropagatedAnnotations: true
define  view entity ZREFX_I_ROW_SITEVISIT as select from zrefx_row_sitevi

  association        to parent ZREFX_I_ROW_PROPOSEDLAND     as _ProposedLand     on  $projection.RequestId  = _ProposedLand.RequestId
                                                                     and $projection.ProposalLandId = _ProposedLand.Id
                                                                     and $projection.ProposalId = _ProposedLand.ProposalId
                                                                     

  association [0..*] to ZREFX_I_ROW_REQUEST        as _LandRequest  on  $projection.RequestId = _LandRequest.RequestId


  association [0..*] to ZREFX_I_ROW_SITEVISITNOM        as _SiteVisitNom on  $projection.RequestId = _SiteVisitNom.RequestId


 // association [0..*] to ZREFX_I_USERREF             as _UserRef      on  $projection.Engineer = _UserRef.UserID

  association        to ZREFX_I_ROW_STATUS              as _Status       on  _Status.Statustype     = 'SITEVISIT'
                                                                     and $projection.Statuscode = _Status.Code

  association [1..1] to ZREFX_I_ROW_WORKFLOW_INSTANCE   as _Workflow     on  _Workflow.Objecttype = 'SITEVISIT'

  composition of many ZREFX_I_ROW_SITEVISIT_ATT as _Attachments
{
    
     key id                   as ID,
  key proposalid           as ProposalId,
  key proposalandid           as ProposalLandId,
  key request_id           as RequestId,

      _ProposedLand.Landid as Proposedland,
      proposal             as Proposal,
     
      plannedvisitdatetime as Plannedvisitdatetime,
      actualvisitdatetime  as Actualvisitdatetime,
      engineer      as Engineer,
      statuscode           as Statuscode,
      _Status._Text.Description  as Status,
      reports              as Reports,
      widthmmeasured       as Widthmmeasured,
      lengthmmeasured      as Lengthmmeasured,
      areasqmmeasured      as Areasqmmeasured,
      obstacles            as Obstacles,
      safetyobservations   as Safetyobservations,
      sitenotes            as Sitenotes,
      title                     as Title,
      department                as Department,
      userid                    as UserId,
      username                  as UserName,
      

      _Workflow,
      _Attachments,

    //  _UserRef,
      _Status,
      _SiteVisitNom,
      _ProposedLand,
      _LandRequest
}
