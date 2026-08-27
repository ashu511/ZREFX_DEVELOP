@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view - Site Visit'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_GL_SITEVISIT
  as projection on ZREFX_I_GL_SITEVISIT
{
  key   ID,
  key   RequestId,
        Plannedvisitdatetime,
        Actualvisitdatetime,
        Engineer,
        Statuscode,
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
        _SiteAttachments : redirected to composition child ZREFX_C_GL_SITEVISIT_ATT,
        _SiteVisitNom    : redirected to composition child ZREFX_C_GL_SITEVISITNOM,
        _GLRequest       : redirected to parent ZREFX_C_GL_REQUEST

}
