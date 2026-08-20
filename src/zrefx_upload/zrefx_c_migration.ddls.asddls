@EndUserText.label: 'Migration Cockpit Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZREFX_C_MIGRATION
  provider contract transactional_query
  as projection on ZREFX_I_MIGRATION
{
  key JobUuid,
      @ObjectModel.text.element: ['TargetDescription']
      TargetObject,
      @UI.hidden: true
      _TargetVH.Description as TargetDescription,
      @Semantics.largeObject: { mimeType: 'MimeType', fileName: 'FileName', contentDispositionPreference: #ATTACHMENT }
      FileContent,
      MimeType,
      FileName,
      Status,
      StatusCriticality,
      CreatedBy,
      CreatedAt,
      LastChangedAt,

      @UI.hidden: true
      HideComplaints,
      @UI.hidden: true
      HideClaims,

      @EndUserText.label: 'Download Template'
      @Semantics.largeObject: { mimeType: 'TemplateMime', fileName: 'TemplateName', contentDispositionPreference: #ATTACHMENT }
      TemplateContent,
      TemplateMime,
      TemplateName,

      /* Associations */
      _ComplaintsItems : redirected to composition child ZREFX_C_MIG_S_COMP,
      _ClaimsItems     : redirected to composition child ZREFX_C_MIG_S_CLM

}
