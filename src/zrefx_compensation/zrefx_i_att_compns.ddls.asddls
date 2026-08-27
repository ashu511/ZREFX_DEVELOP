@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Compensation Attachments'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ATT_COMPNS
  as select from zrefx_att_compns
  association to parent ZREFX_I_COMPENSATION as _Compensation on $projection.CompensationId = _Compensation.CompensationId
{
  key compns_id     as CompensationId,
  key attachment_id as AttachmentId,
      dmsid         as Dmsid,
      documenttype  as Documenttype,
      documentname  as Documentname,
      category      as Category,
      filename      as Filename,
      mediatype     as Mediatype,
      mimetype      as Mimetype,
      content       as Content,
      notes         as Notes,
      created_by    as CreatedBy,
      created_at    as CreatedAt,
      _Compensation

}
