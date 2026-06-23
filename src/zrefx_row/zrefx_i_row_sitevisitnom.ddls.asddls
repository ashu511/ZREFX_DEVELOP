@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Site Visit Nomination'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_SITEVISITNOM
  as select from zrefx_row_svn
  association        to parent ZREFX_I_ROW_PROPOSEDLAND as _ProposedLand on  $projection.RequestId       = _ProposedLand.RequestId
                                                                       and $projection.ProposalLand_Id = _ProposedLand.Id
                                                                       and $projection.ProposalId      = _ProposedLand.ProposalId

  association [0..*] to ZREFX_I_ROW_REQUEST           as _LandRequest on  $projection.RequestId = _LandRequest.RequestId

  // association [1..1] to ZREFX_I_USERREF             as _UserRef      on  $projection.Nominatedby = _UserRef.UserID

  association        to ZREFX_I_ROW_STATUS            as _Status      on  _Status.Statustype     = 'NOMINATION'
                                                                      and $projection.Statuscode = _Status.Code

  association [1..1] to ZREFX_I_ROW_WORKFLOW_INSTANCE as _Workflow    on  _Workflow.Objecttype = 'NOMINATION'
{

  key   id                        as ID,
  key   proposalid                as ProposalId,
  key   proposallandid            as ProposalLand_Id,
  key   request_id                as RequestId,
        _ProposedLand.Landid      as Proposedlandid,

        nominatedat               as Nominatedat,
        engineer                  as Engineer,
        nominatedby               as Nominatedby,
        visitreason               as Visitreason,
        priority                  as Priority,
        preoposeddatetime         as Preoposeddatetime,
        agreeddatetime            as Agreeddatetime,
        notes                     as Notes,
        _Status._Text.Description as Status,
        statuscode                as Statuscode,
        acceptedby                as Acceptedby,
        acceptedat                as Acceptedat,
        acceptancecomment         as Acceptancecomment,
        declinereason             as Declinereason,
        title                     as Title,
        department                as Department,
        userid                    as UserId,
        username                  as UserName,
        division                  as Division,
        emailid                   as EmailId,
        contactno                 as ContactNo,

        _Workflow,
        _ProposedLand,
        _LandRequest,
        //_UserRef,
        _Status
}
