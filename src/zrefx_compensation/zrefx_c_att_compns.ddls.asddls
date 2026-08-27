@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Compensation Attachment'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_ATT_COMPNS as projection on ZREFX_I_ATT_COMPNS
{
    key CompensationId,
    key AttachmentId,
    Dmsid,
    Documenttype,
    Documentname,
    Category,
    Filename,
    Mediatype,
    Mimetype,
    Content,
    Notes,
    CreatedBy,
    CreatedAt,
    /* Associations */
    _Compensation : redirected to parent ZREFX_C_COMPENSATION
}
