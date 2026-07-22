@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'REFX Claims Attachments'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_ATT_CLAIMS
  as select from zrefx_att_claims
  association to parent ZREFX_I_CLAIMS as _claims on $projection.ClaimId = _claims.Claimid
{
  key claim_id              as ClaimId,
  key attachment_id         as AttachmentId,
      dmsid                 as Dmsid,
      category              as Category,
      filename              as Filename,
      mimetype              as Mimetype,
      content               as Content,
      mediatype             as Mediatype,
      documentname          as Documentname,
      documenttype          as Documenttype,
      notes                 as Notes,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      _claims.Lastchangedat as Lastchangedat,
      _claims
      
      
      
      
      
}
