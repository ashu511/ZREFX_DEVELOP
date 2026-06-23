@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Site Visit Attachment for ROW Projection'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_C_ROW_SITEVISIT_ATT 
as projection on   ZREFX_I_ROW_SITEVISIT_ATT
{
    
    key  RequestId,
     key Dmsid,
     key SiteId,
     key ProposalId,
     key ProposalLandId,
       Category,
       Documentname,
       Filename,
       DocumentType,
       Mediatype,
       Notes,
       CreatedBy,
       CreatedAt,
       _SiteVisit : redirected to parent ZREFX_C_ROW_SITEVISIT,
       _LandRequest:  redirected to ZREFX_C_ROW_REQUEST
}
