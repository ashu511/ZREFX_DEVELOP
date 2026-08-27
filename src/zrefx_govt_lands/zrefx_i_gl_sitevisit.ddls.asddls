@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Site Visit'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_GL_SITEVISIT
  as select from zrefx_gl_sitevi
  association to parent ZREFX_I_GL_REQUEST as _GLRequest on $projection.RequestId = _GLRequest.RequestId
  composition of many ZREFX_I_GL_SITEVISIT_ATT as _SiteAttachments 
  composition of many ZREFX_I_GL_SITEVISITNOM  as _SiteVisitNom
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
      _GLRequest

}
