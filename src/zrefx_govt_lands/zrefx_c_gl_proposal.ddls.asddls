@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Proposal'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_GL_PROPOSAL
  as projection on ZREFX_I_GL_PROPOSAL
{

  key Id,
  key RequestId,
      Version,
      Proposaldate,
      Preparedby,
      Reviewedby,
      _Status._Text.Description as Status,
      Proposalstatuscode,
      Justification,
      Cownedlandavl,
      Proposedland,
      Selectedland,
      Requestorcomment,
      Focaluser,
      Sponsorname,
      Sponsororg,
      Sponsorcontact,
      Sponsoremail,
      Notes,
      Title,
      Department,
      UserId,
      UserName,

      _LandRequest  : redirected to parent ZREFX_C_GL_REQUEST,
      _ProposedLand : redirected to composition child ZREFX_C_GL_PROPOSEDLAND,
      _Workflow,
      // _UserRef,
      _Status
}
