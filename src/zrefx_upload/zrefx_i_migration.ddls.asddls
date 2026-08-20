@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Migration Cockpit Job'
@Metadata.allowExtensions: true
define root view entity ZREFX_I_MIGRATION
  as select from zrefx_mig_job
  composition [0..*] of ZREFX_I_MIG_S_COMP as _ComplaintsItems
  composition [0..*] of ZREFX_I_MIG_S_CLM  as _ClaimsItems
  association [0..1] to ZREFX_VH_TARGETS   as _TargetVH on $projection.TargetObject = _TargetVH.Value
{
  key job_uuid                               as JobUuid,
      @EndUserText.label: 'Target Application'
      cast(target_object as zrefx_de_target) as TargetObject,
      @EndUserText.label: 'Upload Excel File'
      file_content                           as FileContent,
      mime_type                              as MimeType,
      file_name                              as FileName,
      status                                 as Status,
      case
      when status like 'Error%' then 1       // 1 = Red (Negative)
      when status like 'Migrated%' then 3    // 3 = Green (Positive)
      when status like 'Data Staged%' then 2 // 2 = Orange/Yellow (Critical)
      else 0                                 // 0 = Grey (Neutral)
      end                                    as StatusCriticality,
      @Semantics.user.createdBy: true
      created_by                             as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                             as CreatedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at                        as LastChangedAt,
      // --- ADD NATIVE TEMPLATE DOWNLOAD FIELDS ---
      template_content                       as TemplateContent,
      template_mime                          as TemplateMime,
      template_name                          as TemplateName,
      // -------------------------------------------

      // --- Dynamic Tab Visibility Flags ---
      hide_complaints                        as HideComplaints,
      hide_claims                            as HideClaims,
      // -------------------------------------------

      _ComplaintsItems,
      _ClaimsItems,
      _TargetVH

}
