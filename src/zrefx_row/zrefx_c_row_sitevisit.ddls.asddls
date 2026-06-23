@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view - Site Visit'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_ROW_SITEVISIT
  as projection on ZREFX_I_ROW_SITEVISIT
{
  key   ID,
  key   ProposalId,
  key   ProposalLandId,
  key   RequestId,
        Proposal,
        Proposedland,
        Plannedvisitdatetime,
        Actualvisitdatetime,
        Engineer,
        Statuscode,
        _Status._Text.Description as Status,
        Reports,
        Widthmmeasured,
        Lengthmmeasured,
        Areasqmmeasured,
        Obstacles,
        Safetyobservations,
        Sitenotes,
        Department,
        Title,
        UserId,
        UserName,

        _Workflow,
        _ProposedLand : redirected to parent ZREFX_C_ROW_PROPOSEDLAND,
        _Attachments : redirected to composition child ZREFX_C_ROW_SITEVISIT_ATT,

        // _UserRef,
        _Status,
        _SiteVisitNom,
        _LandRequest  : redirected to ZREFX_C_ROW_REQUEST
}
