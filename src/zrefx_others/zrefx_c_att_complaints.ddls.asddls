@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZREFX Attachments Consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZREFX_C_ATT_COMPLAINTS
  as projection on ZREFX_I_ATT_COMPlAINTS
{
      //  key AttacId,
      //      ComplaintId,
      //      Comments,
      //      @Semantics.largeObject:{
      //      mimeType: 'Mimetype',
      //      fileName: 'Filename',
      //      contentDispositionPreference: #ATTACHMENT
      //      }
      //      Attachment,
      //      Mimetype,
      //      Filename,
  key ComplaintId,
  key AttachmentId,
      Dmsid,
      Documenttype,
      Documentname,
      Category,
      Filename,
      Mediatype,
      @Semantics.mimeType: true
      Mimetype,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_REFX_DMS_CALC_EXIT'
      @Semantics.largeObject: {
        mimeType: 'MimeType',
        fileName: 'Filename',
        contentDispositionPreference: #ATTACHMENT,
        acceptableMimeTypes: ['application/pdf','image/jpeg','image/png',
                              'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
      }
      Content,
      Notes,
      CreatedBy,
      CreatedAt,
      // Lastchangedat
      /* Associations */
      _Complaints : redirected to parent ZREFX_C_COMPLAINTS
}
