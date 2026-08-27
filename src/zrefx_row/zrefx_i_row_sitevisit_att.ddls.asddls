@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Site Visit Attachment for ROW'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ROW_SITEVISIT_ATT
  as select from zrefx_row_visita
  association to parent ZREFX_I_ROW_SITEVISIT as _SiteVisit on  $projection.SiteId    = _SiteVisit.Id
                                                            and $projection.RequestId = _SiteVisit.RequestId
 association [1..1] to ZREFX_I_ROW_REQUEST as _ROW on $projection.RequestId = _ROW.RequestId 
{

  key request_id   as RequestId,
  key dmsid        as Dmsid,
  key siteid       as SiteId,
      category     as Category,
      documentname as Documentname,
      documenttype as DocumentType,
      filename     as Filename,
      mediatype    as Mediatype,
      notes        as Notes,
      created_by   as CreatedBy,
      created_at   as CreatedAt,
      _SiteVisit,
      _ROW


}
