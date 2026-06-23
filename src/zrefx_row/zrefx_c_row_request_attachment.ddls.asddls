@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Request for attachment for ROW Projection'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_ROW_REQUEST_ATTACHMENT as projection on ZREFX_I_ROW_REQUEST_ATTACHMENT
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
      _ROWRequest : redirected to parent ZREFX_C_ROW_REQUEST
}
