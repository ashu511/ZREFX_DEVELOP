@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Complaint Report'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_COMP_ID_VH as select from zrefx_complaints as _Complants

{
    
    key complaint_id as ComplaintId   
}
