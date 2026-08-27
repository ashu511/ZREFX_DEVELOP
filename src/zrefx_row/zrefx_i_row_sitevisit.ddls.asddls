@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request for ROW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
//@ObjectModel.semanticKey: ['RequestId']
define  view entity ZREFX_I_ROW_SITEVISIT
  as select from zrefx_row_sitevi
  association to parent ZREFX_I_ROW_REQUEST as _Row on $projection.RequestId = _Row.RequestId
  composition of many ZREFX_I_ROW_SITEVISIT_ATT as _SiteAttachments
  composition of many ZREFX_I_ROW_SITEVISITNOM  as _SiteVisitNom
{

  key id                   as Id,
  key request_id           as RequestId,
      nomination           as Nomination,
      plannedvisitdatetime as Plannedvisitdatetime,
      actualvisitdatetime  as Actualvisitdatetime,
      engineer             as Engineer,
      statuscode           as Statuscode,
      status               as Status,
      reports              as Reports,
      widthmmeasured       as Widthmmeasured,
      lengthmmeasured      as Lengthmmeasured,
      areasqmmeasured      as Areasqmmeasured,
      obstacles            as Obstacles,
      safetyobservations   as Safetyobservations,
      sitenotes            as Sitenotes,
      department           as Department,
      userid               as Userid,
      username             as Username,
      title                as Title,
      _SiteAttachments,
      _SiteVisitNom,
      _Row

}
