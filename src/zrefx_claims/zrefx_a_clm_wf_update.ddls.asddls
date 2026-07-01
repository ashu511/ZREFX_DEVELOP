@EndUserText.label: 'SBPA Workflow Update Payload'
define abstract entity ZREFX_A_CLM_WF_UPDATE
{
  WfInstanceId      : abap.char(36);
  approvalstep      : abap.char(1);
  approvalstepdesc  : abap.char(40);
  ApproverEmail     : abap.char(255);
  CurrentStatus     : abap.char(16);
  CurrentOwner      : abap.char(80);
  CurrentOwnerDesig : abap.char(250);
  OrganizationField : abap.char(100);
  Comments          : abap.string(256);
  //  AuthorityLevel   : abap.char(2);
  DecisionOutcome   : abap.char(15);
  //  LegalInvolvement : abap.char(15);
}
