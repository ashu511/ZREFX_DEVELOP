@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'WF All steps'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZREFX_I_CLAIMS_WF_ALL_STEPS

  as select from    zrefx_wf_clm as Log
  // Self-join to find any APPROVE or COMPLETED entries for the exact same step
    left outer join zrefx_wf_clm as ApprovedLog on  Log.claim_id                 = ApprovedLog.claim_id
                                                and Log.approvalstep             = ApprovedLog.approvalstep
                                                and (
                                                   ApprovedLog.current_status    = 'APPROVE'
                                                   or ApprovedLog.current_status = 'COMPLETED'
                                                   or ApprovedLog.current_status = 'REJECT'
                                                 )
{
      //  key Log.claim_id             as ClaimId,
      //  key Log.log_uuid             as LogUuid,
      //      Log.approvalstep         as ApprovalStep,
      //      Log.approvalstepdesc     as ApprovalStepDesc,
      //      Log.current_status       as CurrentStatus,
      //      Log.current_owner        as CurrentOwner,
      //      Log.comments             as Comments,
      //
      //      Log.days_open            as DaysOpen,
      //      Log.sla_status           as SlaStatus,
      //      Log.submission_from_date as SubmissionFromDate,
      //      Log.submission_to_date   as SubmissionToDate,
      //      Log.approver_email       as ApproverEmail,

  key Log. claim_id            as ClaimId,
  key Log.log_uuid             as LogUuid,
      Log.wf_instance_id       as WfInstanceId,
      Log.region               as Region,
      Log.approvalstep         as ApprovalStep,
      Log.current_status       as CurrentStatus,
      Log.current_owner        as CurrentOwner,
      Log.submission_from_date as SubmissionFromDate,
      Log.submission_to_date   as SubmissionToDate,
      Log.sla_status           as SlaStatus,
      Log.days_open            as DaysOpen,
      Log.settlement_status    as SettlementStatus,
      Log.posting_from_date    as PostingFromDate,
      Log.posting_to_date      as PostingToDate,
      Log.payment_status       as PaymentStatus,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Log.approved_amount      as ApprovedAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Log.posted_amount        as PostedAmount,
      Log.currency_code        as CurrencyCode,
      Log.account_doc_no       as AccountDocNo,
      Log.payment_date         as PaymentDate,
      Log.aging_from_date      as AgingFromDate,
      Log.aging_to_date        as AgingToDate,
      Log.escalation_flag      as EscalationFlag












}
where
  // 1. Always include COMPLETED items
        Log.current_status         = 'COMPLETED'
  or    Log.current_status         = 'APPROVE'
  or    Log.current_status         = 'REJECT'

  // 2. Always include TRIGGERED / SUBMITTED items
  or    Log.current_status         = 'SUBMITTED'
  or    Log.approvalstepdesc       = 'TRIGGERED'

  // 3. Include PENDING items ONLY if the LEFT JOIN failed to find an approval
  or(
        Log.current_status         = 'PENDING'
    and ApprovedLog.current_status is null
  )
