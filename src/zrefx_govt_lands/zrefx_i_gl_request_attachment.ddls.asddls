@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Request Attachments'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_GL_REQUEST_ATTACHMENT
  as select from zrefx_gl_req_a

  association to parent ZREFX_I_GL_REQUEST as _GLRequest on $projection.RequestId = _GLRequest.RequestId
{
  key request_id   as RequestId,
  key dmsid        as Dmsid,
      documenttype as Documenttype,
      documentname as Documentname,
      category     as Category,
      filename     as Filename,
      mediatype    as Mediatype,

      notes        as Notes,
      created_by   as CreatedBy,
      created_at   as CreatedAt,

      _GLRequest
}
