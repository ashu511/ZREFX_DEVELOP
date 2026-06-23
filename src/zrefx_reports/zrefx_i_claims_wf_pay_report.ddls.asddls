@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Claims Settlement & Payment Status Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZREFX_I_CLAIMS_WF_PAY_REPORT
  as select from zrefx_wf_clm
  association to zrefx_claims as _Claims on $projection.ClaimId = _Claims.claim_id
{
  key zrefx_wf_clm.claim_id       as ClaimId,
      zrefx_wf_clm.wf_instance_id as WfInstanceId,
      _Claims.vendorname          as VendorName,
      _Claims.vendorid            as VendorId,
      posting_from_date           as PostingFromDate,
      posting_to_date             as PostingToDate,
      payment_status              as PaymentStatus,
      currency_code               as CurrencyCode,
      account_doc_no              as AccountDocNo,
      payment_date                as PaymentDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      posted_amount               as PostedAmount,
      _Claims
}
