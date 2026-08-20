@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request for attachment for GL Projection'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_GL_REQUEST_ATTACHMENT
  as projection on ZREFX_I_GL_REQUEST_ATTACHMENT
{
  key RequestId,
  key AttachmentId,
      Dmsid,
      Documenttype,
      Documentname,
      Category,
      Filename,
      Mediatype,
      //      @Semantics.mimeType: true
      Mimetype,
      //      @Semantics.largeObject: {
      //            mimeType: 'MimeType',
      //            fileName: 'Filename',
      //            contentDispositionPreference: #ATTACHMENT
      //        }
      Content,
      Notes,
      CreatedBy,
      CreatedAt,

      /* Associations */
      _GLRequest : redirected to parent ZREFX_C_GL_REQUEST
}
