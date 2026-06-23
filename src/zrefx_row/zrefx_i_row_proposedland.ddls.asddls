@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROW Proposal'
@Metadata.ignorePropagatedAnnotations: true
define  view entity ZREFX_I_ROW_PROPOSEDLAND as select from zrefx_row_propl
association [0..*] to ZREFX_I_ROW_REQUEST         as _LandRequest  on  $projection.RequestId = _LandRequest.RequestId
 
  association to parent ZREFX_I_ROW_PROPOSAL   as _Proposal on $projection.ProposalId = _Proposal.Id and $projection.RequestId = _Proposal.RequestId
  composition of many ZREFX_I_ROW_SITEVISITNOM as _SiteVisitNom     
  composition of many ZREFX_I_ROW_SITEVISIT as _SiteVisit  
{
    
      key id               as Id,
     key proposalid    as ProposalId,
     key request_id     as RequestId,
      landid                   as Landid,
      city                     as City,
      district                 as District,
      postalcode               as Postalcode,
      totalarea                as Totalarea,
      remainingarea            as Remainingarea,
      latitude                 as Latitude,
      longitude                as Longitude,
      gismaplink               as Gismaplink,
      divisionemployeeuserid   as Divisionemployeeuserid,
      divisionemployeefullname as Divisionemployeefullname,
      divisionemployeeremarks  as Divisionemployeeremarks,
      supportingdocuments      as Supportingdocuments,
      isfitsrequirement        as IsFitsRequirement,
      isselectsitevisit        as IsSelectSiteVisit,
      status                   as Status,

      _SiteVisitNom,
      _Proposal,
      _LandRequest,
      _SiteVisit
}
