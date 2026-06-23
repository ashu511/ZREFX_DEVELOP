@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Proposed Land'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_GL_PROPOSEDLAND
  as projection on ZREFX_I_GL_PROPOSEDLAND
{

  key Id,
  key ProposalId,
  key RequestId,
      Landid,
      City,
      District,
      Postalcode,
      Totalarea,
      Remainingarea,
      Latitude,
      Longitude,
      Gismaplink,
      Divisionemployeeuserid,
      Divisionemployeefullname,
      Divisionemployeeremarks,
      Supportingdocuments,
      IsFitsRequirement,
      IsSelectSiteVisit,
      Status,

      _SiteVisitNom : redirected to composition child ZREFX_C_GL_SITEVISITNOM,
      _Proposal     : redirected to parent ZREFX_C_GL_PROPOSAL,
      _LandRequest  : redirected to ZREFX_C_GL_REQUEST,
      _SiteVisit: redirected to composition child ZREFX_C_GL_SITEVISIT
}
