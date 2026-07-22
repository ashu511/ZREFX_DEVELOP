@EndUserText.label: 'Migration Cockpit Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZREFX_C_MIGRATION
  provider contract transactional_query
  as projection on ZREFX_I_MIGRATION
{
  key JobUuid,
      @ObjectModel.text.element: ['TargetDescription']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZREFX_VH_TARGETS', element: 'Value' } }]
      TargetObject,
      @UI.hidden: true
      _TargetVH.Description as TargetDescription,
      FileContent,
      MimeType,
      FileName,
      Status,
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
      @UI.hidden: true
      TemplateMime,
      @UI.hidden: true
      TemplateName,

      /* Associations */
      _ComplaintsItems : redirected to composition child ZREFX_C_MIG_S_COMP,
      _ClaimsItems     : redirected to composition child ZREFX_C_MIG_S_CLM

}
