@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Site Visit Nomination'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_GL_SITEVISITNOM
  as select from zrefx_gl_svn
  association to parent ZREFX_I_GL_SITEVISIT as _SiteVisit on  $projection.Id        = _SiteVisit.Id
                                                            and $projection.RequestId = _SiteVisit.RequestId
  association [1..1] to ZREFX_I_GL_REQUEST as _GLRequest on $projection.RequestId = _GLRequest.RequestId                                                          
{
  key id                as Id,
  key nomid             as NominationId,
  key request_id        as RequestId,
      nominatedby       as Nominatedby,
      nominatedat       as Nominatedat,
      engineer          as Engineer,
      visitreason       as Visitreason,
      priority          as Priority,
      preoposeddatetime as Preoposeddatetime,
      agreeddatetime    as Agreeddatetime,
      notes             as Notes,
      status            as Status,
      statuscode        as Statuscode,
      acceptedby        as Acceptedby,
      acceptedat        as Acceptedat,
      acceptancecomment as Acceptancecomment,
      declinereason     as Declinereason,
      department        as Department,
      userid            as Userid,
      username          as Username,
      title             as Title,
      division          as Division,
      emailid           as Emailid,
      contactno         as Contactno,
      _SiteVisit,
      _GLRequest
      
}

