@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Site Nominations'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_ROW_SITEVISITNOM
  as projection on ZREFX_I_ROW_SITEVISITNOM
{
  key ID,
  key ProposalId,
  key ProposalLand_Id,
  key RequestId,
      Proposedlandid,

      Nominatedby,
      Nominatedat,
      Engineer,
      Visitreason,
      Priority,
      Preoposeddatetime,
      Agreeddatetime,
      Notes,
      _Status._Text.Description as Status,
      Statuscode,
      Acceptedby,
      Acceptedat,
      Acceptancecomment,
      Declinereason,
      Department,
      Title,
      UserId,
      UserName,
      Division,
      EmailId,
      ContactNo,

      _Workflow,
      _LandRequest  : redirected to ZREFX_C_ROW_REQUEST,
      // _UserRef,
      _Status,
      _ProposedLand : redirected to parent ZREFX_C_ROW_PROPOSEDLAND
}
