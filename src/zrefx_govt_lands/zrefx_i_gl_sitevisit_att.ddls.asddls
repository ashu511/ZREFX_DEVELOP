@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Site Visit Attachment for GL'
@Metadata.ignorePropagatedAnnotations: true
define  view entity ZREFX_I_GL_SITEVISIT_ATT 
as select from zrefx_gl_visita
  association [0..*] to ZREFX_I_GL_REQUEST      as _LandRequest on $projection.RequestId = _LandRequest.RequestId

  association        to parent ZREFX_I_GL_SITEVISIT as _SiteVisit   on $projection.RequestId = _SiteVisit.RequestId and $projection.SiteId = _SiteVisit.ID
  and $projection.ProposalId = _SiteVisit.ProposalId
  and $projection.ProposalLandId = _SiteVisit.ProposalLandId
{
    
     key request_id           as RequestId,
  key dmsid                   as Dmsid,
  key siteid               as SiteId,
  key proposalid           as ProposalId,
  key proposallandid       as ProposalLandId,
      category             as Category,
      documentname         as Documentname,
      documenttype         as DocumentType,
      filename             as Filename,
      mediatype            as Mediatype,
      notes                as Notes,
      created_by           as CreatedBy,
      created_at           as CreatedAt,
      _SiteVisit,
      _LandRequest

}
