@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Workflow Tracking Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_COMP_WF_TRACK
  as select from ZREFX_I_COMP_WF_ALL_STEPS
  association to zrefx_complaint as _Complaints on $projection.ComplaintId = _Complaints.complaint_id
{

  key ZREFX_I_COMP_WF_ALL_STEPS.ComplaintId,
  key ZREFX_I_COMP_WF_ALL_STEPS.LogUuid,
      ZREFX_I_COMP_WF_ALL_STEPS.ApprovalStep,
      ZREFX_I_COMP_WF_ALL_STEPS.ApprovalStepDesc,
      ZREFX_I_COMP_WF_ALL_STEPS.CurrentStatus,
      ZREFX_I_COMP_WF_ALL_STEPS.CurrentOwner,
      ZREFX_I_COMP_WF_ALL_STEPS.Comments,
      ZREFX_I_COMP_WF_ALL_STEPS.ClosureDate,
      ZREFX_I_COMP_WF_ALL_STEPS.DaysOpen,
      ZREFX_I_COMP_WF_ALL_STEPS.SlaStatus,
      //      ZREFX_I_COMP_WF_ALL_STEPS.SubmissionFromDate,
      _Complaints.createddate       as SubmissionFromDate,
      ZREFX_I_COMP_WF_ALL_STEPS.SubmissionToDate,
      ZREFX_I_COMP_WF_ALL_STEPS.EscalationTriggered,
      ZREFX_I_COMP_WF_ALL_STEPS.AuthorityLevel,
      ZREFX_I_COMP_WF_ALL_STEPS.DaysPending,
      ZREFX_I_COMP_WF_ALL_STEPS.EscalationDate,
      ZREFX_I_COMP_WF_ALL_STEPS.LegalInvolvement,
      ZREFX_I_COMP_WF_ALL_STEPS.DecisionOutcome,
      ZREFX_I_COMP_WF_ALL_STEPS.LegalReviewReq,
      ZREFX_I_COMP_WF_ALL_STEPS.LegalDecision,
      ZREFX_I_COMP_WF_ALL_STEPS.FinalDecision,
      ZREFX_I_COMP_WF_ALL_STEPS.ApproverEmail,
      _Complaints.complaintcategory as Category,
      _Complaints.legalflag         as Legalflag,
      _Complaints.maindivision      as Maindivision,
      _Complaints.region            as Region,
      _Complaints.sourcechannel     as Source
      //
      //  key ZREFX_I_COMP_WF_ALL_STEPS.ComplaintId,
      //  key ZREFX_I_COMP_WF_ALL_STEPS.LogUuid,
      //      ZREFX_I_COMP_WF_ALL_STEPS.ApprovalStep,
      //      ZREFX_I_COMP_WF_ALL_STEPS.ApprovalStepDesc,
      //      ZREFX_I_COMP_WF_ALL_STEPS.CurrentStatus,
      //  ZREFX_I_COMP_WF_ALL_STEPS.CurrentOwner,
      //  ZREFX_I_COMP_WF_ALL_STEPS.Comments,
      //  ZREFX_I_COMP_WF_ALL_STEPS.ClosureDate,
      //
      //
      //
      ////         wf_instance_id                as WfInstanceId,
      //        _Complaints.complaintcategory as Category,
      //        _Complaints.sourcechannel     as Source,
      //        _Complaints.region            as Region,
      //        _Complaints.maindivision      as Maindivision,
      //        _Complaints.legalflag         as Legalflag,
      ////        current_status                as CurrentStatus,
      // //       current_owner                 as CurrentOwner,
      //        days_open                     as DaysOpen,
      //        sla_status                    as SlaStatus,
      //        submission_from_date          as SubmissionFromDate,
      //        submission_to_date            as SubmissionToDate,
      //        escalation_triggered          as EscalationTriggered,
      //        authority_level               as AuthorityLevel,
      //        days_pending                  as DaysPending,
      //        escalation_date               as EscalationDate,
      //        legal_involvement             as LegalInvolvement,
      //        decision_outcome              as DecisionOutcome,
      //        legal_review_req              as LegalReviewReq,
      //        legal_decision                as LegalDecision,
      //        final_decision                as FinalDecision,
      //        closure_date                  as ClosureDate,
      //        _Complaints
      //
}


//  as select from ZREFX_I_COMP_WF_ALL_STEPS as Header
//
////    inner join   zrefx_wf_com              as WF_Items on  WF_Items.complaint_id = Header.ComplaintId
////                                                       and WF_Items.approvalstep = Header.MaxApprovalStep
//
//
//    inner join   zrefx_complaint              as Comp  on Comp.complaint_id = Header.ComplaintId
//{
//  key WF_Items.complaint_id         as ComplaintId,
//  key WF_Items.log_uuid             as LogUuid,
//      WF_Items.wf_instance_id       as WfInstanceId,
//      Comp.complaintcategory        as Category,
//              Comp.sourcechannel     as Source,
//              Comp.region            as Region,
//              Comp.maindivision      as Maindivision,
//              Comp.legalflag         as Legalflag,
//
//      Header.MaxApprovalStep         as Approvalstep,
//      WF_Items.approvalstepdesc     as Approvalstepdesc,
//      WF_Items.approver_email       as ApproverEmail,
//      WF_Items.current_status       as CurrentStatus,
//      WF_Items.current_owner        as CurrentOwner,
//
//      WF_Items.days_open            as DaysOpen,
//      WF_Items.sla_status           as SlaStatus,
//      WF_Items.submission_from_date as SubmissionFromDate,
//      WF_Items.submission_to_date   as SubmissionToDate,
//      WF_Items.escalation_triggered as EscalationTriggered,
//      WF_Items.authority_level      as AuthorityLevel,
//      WF_Items.days_pending         as DaysPending,
//      WF_Items.escalation_date      as EscalationDate,
//      WF_Items.legal_involvement    as LegalInvolvement,
//      WF_Items.decision_outcome     as DecisionOutcome,
//      WF_Items.legal_review_req     as LegalReviewReq,
//      WF_Items.legal_decision       as LegalDecision,
//      WF_Items.final_decision       as FinalDecision,
//      WF_Items.closure_date         as ClosureDate
//
//
//}
