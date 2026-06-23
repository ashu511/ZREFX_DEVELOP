@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'REFX Complaints Attachments'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ATT_COMPlAINTS
  as select from zrefx_att_comp
  association to parent ZREFX_I_COMPLAINTS as _Complaints on $projection.ComplaintId = _Complaints.ComplaintId

{
      //  key attac_id     as AttacId,
      //      zrefx_att_comp.complaint_id as ComplaintId,
      //      comments     as Comments,
      //
      //     attachment   as Attachment,
      //      mimetype     as Mimetype,
      //      filename     as Filename,
  key zrefx_att_comp.complaint_id  as ComplaintId,
  key zrefx_att_comp.attachment_id as AttachmentId,
      zrefx_att_comp.dmsid         as Dmsid,
      zrefx_att_comp.documenttype  as Documenttype,
      zrefx_att_comp.documentname  as Documentname,
      zrefx_att_comp.category      as Category,
      zrefx_att_comp.filename      as Filename,
      zrefx_att_comp.mediatype     as Mediatype,
      zrefx_att_comp.mimetype      as Mimetype,      
      zrefx_att_comp.content       as Content,      
      zrefx_att_comp.notes         as Notes,
      zrefx_att_comp.created_by    as CreatedBy,
      zrefx_att_comp.created_at    as CreatedAt,

      //      zrefx_att_comp.filename     as Filename,
      _Complaints.Lastchangedat    as Lastchangedat,
      _Complaints


}
