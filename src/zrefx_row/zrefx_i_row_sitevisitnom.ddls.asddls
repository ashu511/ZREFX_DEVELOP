@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Site Visit Nomination'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_SITEVISITNOM
  as select from zrefx_row_svn
  association to parent ZREFX_I_ROW_SITEVISIT as _SiteVisit on  $projection.Id        = _SiteVisit.Id
                                                            and $projection.RequestId = _SiteVisit.RequestId
   association [1..1] to ZREFX_I_ROW_REQUEST as _ROW on $projection.RequestId = _ROW.RequestId                                                           
{
  key zrefx_row_svn.id                as Id,
  key zrefx_row_svn.request_id        as RequestId,
      zrefx_row_svn.nominatedby       as Nominatedby,
      zrefx_row_svn.nominatedat       as Nominatedat,
      zrefx_row_svn.engineer          as Engineer,
      zrefx_row_svn.visitreason       as Visitreason,
      zrefx_row_svn.priority          as Priority,
      zrefx_row_svn.preoposeddatetime as Preoposeddatetime,
      zrefx_row_svn.agreeddatetime    as Agreeddatetime,
      zrefx_row_svn.notes             as Notes,
      zrefx_row_svn.status            as Status,
      zrefx_row_svn.statuscode        as Statuscode,
      zrefx_row_svn.acceptedby        as Acceptedby,
      zrefx_row_svn.acceptedat        as Acceptedat,
      zrefx_row_svn.acceptancecomment as Acceptancecomment,
      zrefx_row_svn.declinereason     as Declinereason,
      zrefx_row_svn.department        as Department,
      zrefx_row_svn.userid            as Userid,
      zrefx_row_svn.username          as Username,
      zrefx_row_svn.title             as Title,
      zrefx_row_svn.division          as Division,
      zrefx_row_svn.emailid           as Emailid,
      zrefx_row_svn.contactno         as Contactno,
      _SiteVisit,
      _ROW

}
