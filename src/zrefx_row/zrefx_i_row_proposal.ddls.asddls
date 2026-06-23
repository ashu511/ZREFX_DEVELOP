@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Proposal for ROW'
@Metadata.ignorePropagatedAnnotations: true
define  view entity ZREFX_I_ROW_PROPOSAL as select from zrefx_row_psl
  association    to parent ZREFX_I_ROW_REQUEST as _LandRequest on  $projection.RequestId = _LandRequest.RequestId
                                                                 
  //association [1..1] to ZREFX_I_USERREF            as _UserRef     on  $projection.Preparedby = _UserRef.UserID

  association        to ZREFX_I_ROW_STATUS             as _Status      on  _Status.Statustype             = 'PROPOSAL'
                                                                 and $projection.Proposalstatuscode = _Status.Code

  association [1..1] to ZREFX_I_ROW_WORKFLOW_INSTANCE  as _Workflow    on  _Workflow.Objecttype  = 'PROPOSAL'

    association to ZREFX_I_ROW_PROPOSEDLAND as _Land on $projection.RequestId = _Land.RequestId

  composition of many ZREFX_I_ROW_PROPOSEDLAND         as _ProposedLand
{
    
       key id                      as Id,
      key request_id                 as RequestId,
      version                    as Version,
      proposaldate               as Proposaldate,
      
      reviewedby            as Reviewedby,
      _Status._Text.Description        as Status,
      proposalstatuscode         as Proposalstatuscode,
      justification              as Justification,
      cownedlandavl              as Cownedlandavl,
      proposedlands              as Proposedland,
      selectedland               as Selectedland,
      requestorcomment           as Requestorcomment,
      focaluser            as Focaluser,
      preparedby            as Preparedby,
      sponsorname                as Sponsorname,
      sponsororg                 as Sponsororg,
      sponsorcontact             as Sponsorcontact,
      sponsoremail               as Sponsoremail,
      notes                      as Notes,
      title                     as Title,
      department                as Department,
      userid                    as UserId,
      username                  as UserName,

      _LandRequest,
     _ProposedLand,
      _Workflow,
     // _UserRef,
      _Status
}
