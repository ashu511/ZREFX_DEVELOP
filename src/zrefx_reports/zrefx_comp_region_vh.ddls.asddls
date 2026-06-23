@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Complaint Report'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_COMP_REGION_VH as select distinct from zrefx_complaints as _Complants

{
    
    key region as Region 
}
