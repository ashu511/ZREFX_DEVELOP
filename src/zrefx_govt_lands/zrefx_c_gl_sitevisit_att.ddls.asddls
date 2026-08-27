@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Site Visit Attachment for ROW Projection'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_GL_SITEVISIT_ATT
  as projection on ZREFX_I_GL_SITEVISIT_ATT
{

  key  RequestId,
  key  Dmsid,
  key  SiteId,
       Category,
       Documentname,
       Filename,
       DocumentType,
       Mediatype,
       Notes,
       CreatedBy,
       CreatedAt,
       _GLRequest : redirected to ZREFX_C_GL_REQUEST,
       _SiteVisit : redirected to parent ZREFX_C_GL_SITEVISIT
}
