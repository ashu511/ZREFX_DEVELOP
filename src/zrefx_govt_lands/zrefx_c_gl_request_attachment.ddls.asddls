@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request for attachment for GL Projection'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_GL_REQUEST_ATTACHMENT 
as projection on ZREFX_I_GL_REQUEST_ATTACHMENT
{

    
    key RequestId,
    key Dmsid,
     
      Documenttype,
      Documentname,
      Category,
      Filename,
      Mediatype,
      Notes,
      CreatedBy,
      CreatedAt,
      
      /* Associations */
      _GLRequest : redirected to parent ZREFX_C_GL_REQUEST
}
