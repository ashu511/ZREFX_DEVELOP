@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZREFX Attachments Claims'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZREFX_C_ATT_CLAIMS
  as projection on ZREFX_I_ATT_CLAIMS
{
  key ClaimId,
  key AttachmentId,
      Dmsid,
      Filename,
      @Semantics.mimeType: true
      Mimetype,
      @ObjectModel.virtualElementCalculatedBy: 'ZCL_REFX_DMS_CALC_EXIT_CLM'
      @Semantics.largeObject: {
        mimeType: 'MimeType',
        fileName: 'Filename',
        contentDispositionPreference: #ATTACHMENT,
        acceptableMimeTypes: ['application/pdf','image/jpeg','image/png',
                              'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
      }
      Content,
      CreatedBy,
      CreatedAt,
      /* Associations */
      _claims : redirected to parent ZREFX_C_CLAIMS
}
