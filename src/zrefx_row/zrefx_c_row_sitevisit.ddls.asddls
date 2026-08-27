@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Land Request'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['RequestId']
define  view entity ZREFX_C_ROW_SITEVISIT
//
  as projection on ZREFX_I_ROW_SITEVISIT
{
  key   Id,
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
        Userid,
        Username,
        _SiteAttachments : redirected to composition child ZREFX_C_ROW_SITEVISIT_ATT,
        _SiteVisitNom    : redirected to composition child ZREFX_C_ROW_SITEVISITNOM,
         _Row : redirected to parent ZREFX_C_ROW_REQUEST

}
