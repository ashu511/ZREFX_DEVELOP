@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Site Nominations'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_ROW_SITEVISITNOM
  as projection on ZREFX_I_ROW_SITEVISITNOM
{
  key Id,
  key RequestId,
      Nominatedby,
      Nominatedat,
      Engineer,
      Visitreason,
      Priority,
      Preoposeddatetime,
      Agreeddatetime,
      Notes,
      Status,
      Statuscode,
      Acceptedby,
      Acceptedat,
      Acceptancecomment,
      Declinereason,
      Department,
      Userid,
      Username,
      Title,
      Division,
      Emailid,
      Contactno,
      /* Associations */
      _SiteVisit : redirected to parent ZREFX_C_ROW_SITEVISIT
}
