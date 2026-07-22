CLASS lhc_complaintsitems DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR ComplaintsItems RESULT result.

ENDCLASS.

CLASS lhc_complaintsitems IMPLEMENTATION.

  METHOD get_global_features.

    " Disable manual UI creation for child tables
    result-%delete = if_abap_behv=>fc-o-disabled.
    result-%update = if_abap_behv=>fc-o-disabled.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_claimsitems DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR ClaimsItems RESULT result.

ENDCLASS.

CLASS lhc_claimsitems IMPLEMENTATION.

  METHOD get_global_features.

    " Disable manual UI creation for child tables
    result-%delete = if_abap_behv=>fc-o-disabled.
    result-%update = if_abap_behv=>fc-o-disabled.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Migration DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Migration RESULT result.

    METHODS parseExcel FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Migration~parseExcel.

    METHODS executeMigration FOR DETERMINE ON SAVE
      IMPORTING keys FOR Migration~executeMigration.

ENDCLASS.

CLASS lhc_Migration IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD parseExcel.

    " ==========================================================================
    " TYPE DEFINITIONS (Used for BOTH Template Generation and File Reading)
    " ==========================================================================
    TYPES: BEGIN OF ty_comp_excel,
             complaint_id        TYPE string,
             createddate         TYPE string,
             vendorid            TYPE string,
             vendorcompanyname   TYPE string,
             contactpersonname   TYPE string,
             contactmobile       TYPE string,
             contactemail        TYPE string,
             legalflag           TYPE string,
             complaintcategory   TYPE string,
             sourcechannel       TYPE string,
             complainttype       TYPE string,
             urgency             TYPE string,
             referencetype       TYPE string,
             referenceid         TYPE string,
             landid              TYPE string,
             titledeedno         TYPE string,
             projectid           TYPE string,
             claimreferenceno    TYPE string,
             region              TYPE string,
             detaileddescription TYPE string,
             financialimpact     TYPE string,
           END OF ty_comp_excel.

    TYPES: BEGIN OF ty_clm_excel,
             claim_id             TYPE string,
             createddate          TYPE string,
             vendorid             TYPE string,
             contactpersonname    TYPE string,
             vendorregistrationno TYPE string,
             contactemail         TYPE string,
             claimcategory        TYPE string,
             sourcechannel        TYPE string,
             claimtype            TYPE string,
             urgency              TYPE string,
             referencetype        TYPE string,
             referenceid          TYPE string,
             leasenumber          TYPE string,
             projectid            TYPE string,
             projectname          TYPE string,
             claimreferenceno     TYPE string,
             region               TYPE string,
             city                 TYPE string,
             claimsubject         TYPE string,
             incidentdate         TYPE string,
             requestedpaymentdate TYPE string,
             detaileddescription  TYPE string,
             claimamount          TYPE string,
           END OF ty_clm_excel.

    READ ENTITIES OF zrefx_i_migration IN LOCAL MODE
    ENTITY Migration ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_headers).

    LOOP AT lt_headers INTO DATA(ls_header).

      " A. CALCULATE FLAGS & PREPARE STATUS
      DATA(lv_hide_comp) = COND abap_boolean( WHEN ls_header-TargetObject = '01' THEN abap_false ELSE abap_true ).
      DATA(lv_hide_clm)  = COND abap_boolean( WHEN ls_header-TargetObject = '02' THEN abap_false ELSE abap_true ).
      DATA(lv_status)    = ls_header-Status.

      " ==============================================================================
      " TEMPLATE GENERATION (Generates the empty Excel file based on dropdown)
      " ==============================================================================
      DATA lv_template_content TYPE xstring.
      DATA lv_template_name    TYPE string.
      DATA lv_template_mime    TYPE string VALUE 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'.

      IF ls_header-TargetObject IS NOT INITIAL.
        DATA(lo_write_access) = xco_cp_xlsx=>document->empty( )->write_access( ).
        DATA(lo_worksheet_temp) = lo_write_access->get_workbook( )->worksheet->at_position( 1 ).

        IF ls_header-TargetObject = '01'. " Complaints
          " Pass an internal table of STRUCTURES to prevent MOVE_CAST_ERROR dump
          DATA lt_comp_header TYPE STANDARD TABLE OF ty_comp_excel.
          APPEND VALUE #(
             complaint_id        = 'COMPLAINT_ID'
             createddate         = 'CREATEDDATE'
             vendorid            = 'VENDORID'
             vendorcompanyname   = 'VENDORCOMPANYNAME'
             contactpersonname   = 'CONTACTPERSONNAME'
             contactmobile       = 'CONTACTMOBILE'
             contactemail        = 'CONTACTEMAIL'
             legalflag           = 'LEGALFLAG'
             complaintcategory   = 'COMPLAINTCATEGORY'
             sourcechannel       = 'SOURCECHANNEL'
             complainttype       = 'COMPLAINTTYPE'
             urgency             = 'URGENCY'
             referencetype       = 'REFERENCETYPE'
             referenceid         = 'REFERENCEID'
             landid              = 'LANDID'
             titledeedno         = 'TITLEDEEDNO'
             projectid           = 'PROJECTID'
             claimreferenceno    = 'CLAIMREFERENCENO'
             region              = 'REGION'
             detaileddescription = 'DETAILEDDESCRIPTION'
             financialimpact     = 'FINANCIALIMPACT'
          ) TO lt_comp_header.

          lv_template_name = 'Complaints_Template.xlsx'.

          lo_worksheet_temp->select( xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
            )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
            )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 1 ) )->get_pattern( )
          )->row_stream( )->operation->write_from( REF #( lt_comp_header ) )->execute( ).

        ELSEIF ls_header-TargetObject = '02'. " Claims
          DATA lt_clm_header TYPE STANDARD TABLE OF ty_clm_excel.
          APPEND VALUE #(
             claim_id             = 'CLAIM_ID'
             createddate          = 'CREATEDDATE'
             vendorid             = 'VENDORID'
             contactpersonname    = 'CONTACTPERSONNAME'
             vendorregistrationno = 'VENDORREGISTRATIONNO'
             contactemail         = 'CONTACTEMAIL'
             claimcategory        = 'CLAIMCATEGORY'
             sourcechannel        = 'SOURCECHANNEL'
             claimtype            = 'CLAIMTYPE'
             urgency              = 'URGENCY'
             referencetype        = 'REFERENCETYPE'
             referenceid          = 'REFERENCEID'
             leasenumber          = 'LEASENUMBER'
             projectid            = 'PROJECTID'
             projectname          = 'PROJECTNAME'
             claimreferenceno     = 'CLAIMREFERENCENO'
             region               = 'REGION'
             city                 = 'CITY'
             claimsubject         = 'CLAIMSUBJECT'
             incidentdate         = 'INCIDENTDATE'
             requestedpaymentdate = 'REQUESTEDPAYMENTDATE'
             detaileddescription  = 'DETAILEDDESCRIPTION'
             claimamount          = 'CLAIMAMOUNT'
          ) TO lt_clm_header.

          lv_template_name = 'Claims_Template.xlsx'.

          lo_worksheet_temp->select( xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
            )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
            )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 1 ) )->get_pattern( )
          )->row_stream( )->operation->write_from( REF #( lt_clm_header ) )->execute( ).
        ENDIF.

        lv_template_content = lo_write_access->get_file_content( ).
      ENDIF.

      " B. PRE-CLEANUP: Empty existing preview items
      READ ENTITIES OF zrefx_i_migration IN LOCAL MODE
        ENTITY Migration BY \_ComplaintsItems ALL FIELDS WITH VALUE #( ( %tky = ls_header-%tky ) ) RESULT DATA(lt_old_comp)
        ENTITY Migration BY \_ClaimsItems ALL FIELDS WITH VALUE #( ( %tky = ls_header-%tky ) ) RESULT DATA(lt_old_clm).

      IF lt_old_comp IS NOT INITIAL.
        MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
          ENTITY ComplaintsItems DELETE FROM VALUE #( FOR comp IN lt_old_comp ( %tky = comp-%tky ) ).
      ENDIF.

      IF lt_old_clm IS NOT INITIAL.
        MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
          ENTITY ClaimsItems DELETE FROM VALUE #( FOR clm IN lt_old_clm ( %tky = clm-%tky ) ).
      ENDIF.

      " C. GUARD CLAUSES: Single COMBINED Modify!
      IF ls_header-TargetObject IS INITIAL.
        lv_status = 'Please select a Target Application'.
        CLEAR: lv_template_content, lv_template_name, lv_template_mime.
        MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
                  ENTITY Migration UPDATE FIELDS ( HideComplaints HideClaims Status TemplateContent TemplateName TemplateMime )
                  WITH VALUE #( ( %tky            = ls_header-%tky
                                  HideComplaints  = lv_hide_comp
                                  HideClaims      = lv_hide_clm
                                  Status          = lv_status
                                  TemplateContent = lv_template_content
                                  TemplateName    = lv_template_name
                                  TemplateMime    = lv_template_mime ) ).
        CONTINUE.
      ENDIF.

      IF ls_header-FileContent IS INITIAL.
        lv_status = 'Waiting for Excel file upload'.
        MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
                  ENTITY Migration UPDATE FIELDS ( HideComplaints HideClaims Status TemplateContent TemplateName TemplateMime )
                  WITH VALUE #( ( %tky            = ls_header-%tky
                                  HideComplaints  = lv_hide_comp
                                  HideClaims      = lv_hide_clm
                                  Status          = lv_status
                                  TemplateContent = lv_template_content
                                  TemplateName    = lv_template_name
                                  TemplateMime    = lv_template_mime ) ).
        CONTINUE.
      ENDIF.

      " D. PARSE FILE
      TRY.
          DATA(lo_document) = xco_cp_xlsx=>document->for_file_content( ls_header-FileContent ).
          DATA(lo_worksheet) = lo_document->read_access( )->get_workbook( )->worksheet->at_position( 1 ).
          DATA(lo_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
            )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
            )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 )
            )->get_pattern( ).

          CASE ls_header-TargetObject.
            WHEN '01'. " Complaints
              DATA lt_comp_excel TYPE STANDARD TABLE OF ty_comp_excel.
              lo_worksheet->select( lo_pattern )->row_stream( )->operation->write_to( REF #( lt_comp_excel ) )->execute( ).

              DATA lt_create_comp TYPE TABLE FOR CREATE zrefx_i_migration\_ComplaintsItems.
              APPEND VALUE #(
                %tky = ls_header-%tky
                %target = VALUE #( FOR ls_c IN lt_comp_excel INDEX INTO i (
                    %cid                = |COMP_{ i }|
                    %is_draft           = if_abap_behv=>mk-on
                    Status              = '06' " Closed
                    Createddate         = ls_c-createddate
                    Vendorid            = ls_c-vendorid
                    Vendorcompanyname   = ls_c-vendorcompanyname
                    Contactpersonname   = ls_c-contactpersonname
                    Contactmobile       = ls_c-contactmobile
                    Contactemail        = ls_c-contactemail
                    Legalflag           = COND #( WHEN ls_c-legalflag = 'X' OR ls_c-legalflag = 'Y' THEN abap_true ELSE abap_false )
                    Complaintcategory   = ls_c-complaintcategory
                    Sourcechannel       = ls_c-sourcechannel
                    Complainttype       = ls_c-complainttype
                    Urgency             = ls_c-urgency
                    Referencetype       = ls_c-referencetype
                    Referenceid         = ls_c-referenceid
                    Landid              = ls_c-landid
                    Titledeedno         = ls_c-titledeedno
                    Projectid           = ls_c-projectid
                    Claimreferenceno    = ls_c-claimreferenceno
                    Region              = ls_c-region
                    Detaileddescription = ls_c-detaileddescription
                    Financialimpact     = ls_c-financialimpact
                ) )
              ) TO lt_create_comp.

              MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
                ENTITY Migration CREATE BY \_ComplaintsItems FIELDS (
                  Status Createddate Vendorid Vendorcompanyname Contactpersonname Contactmobile
                  Contactemail Legalflag Complaintcategory Sourcechannel Complainttype Urgency Referencetype
                  Referenceid Landid Titledeedno Projectid Claimreferenceno Region Detaileddescription Financialimpact
                ) WITH lt_create_comp.

              DATA(lv_rows) = lines( lt_comp_excel ).

            WHEN '02'. " Claims
              DATA lt_clm_excel TYPE STANDARD TABLE OF ty_clm_excel.
              lo_worksheet->select( lo_pattern )->row_stream( )->operation->write_to( REF #( lt_clm_excel ) )->execute( ).

              DATA lt_create_clm TYPE TABLE FOR CREATE zrefx_i_migration\_ClaimsItems.
              APPEND VALUE #(
                %tky = ls_header-%tky
                %target = VALUE #( FOR ls_l IN lt_clm_excel INDEX INTO j (
                    %cid                 = |CLM_{ j }|
                    %is_draft            = if_abap_behv=>mk-on
                    Status               = '06' " Closed
                    Createddate          = ls_l-createddate
                    Vendorid             = ls_l-vendorid
                    Contactpersonname    = ls_l-contactpersonname
                    Vendorregistrationno = ls_l-vendorregistrationno
                    Contactemail         = ls_l-contactemail
                    Claimcategory        = ls_l-claimcategory
                    Sourcechannel        = ls_l-sourcechannel
                    Claimtype            = ls_l-claimtype
                    Urgency              = ls_l-urgency
                    Referencetype        = ls_l-referencetype
                    Referenceid          = ls_l-referenceid
                    Leasenumber          = ls_l-leasenumber
                    Projectid            = ls_l-projectid
                    Projectname          = ls_l-projectname
                    Claimreferenceno     = ls_l-claimreferenceno
                    Region               = ls_l-region
                    City                 = ls_l-city
                    Claimsubject         = ls_l-claimsubject
                    Incidentdate         = ls_l-incidentdate
                    Requestedpaymentdate = ls_l-requestedpaymentdate
                    Detaileddescription  = ls_l-detaileddescription
                    Claimamount          = ls_l-claimamount
                ) )
              ) TO lt_create_clm.

              MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
                ENTITY Migration CREATE BY \_ClaimsItems FIELDS (
                  Status Createddate Vendorid Contactpersonname Vendorregistrationno Contactemail
                  Claimcategory Sourcechannel Claimtype Urgency Referencetype Referenceid Leasenumber
                  Projectid Projectname Claimreferenceno Region City Claimsubject Incidentdate
                  Requestedpaymentdate Detaileddescription Claimamount
                ) WITH lt_create_clm.

              lv_rows = lines( lt_clm_excel ).
          ENDCASE.

          " Single COMBINED Modify for success!
          lv_status = |Data Staged: { lv_rows } rows parsed. Review below.|.
          MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
                      ENTITY Migration UPDATE FIELDS ( HideComplaints HideClaims Status TemplateContent TemplateName TemplateMime )
                      WITH VALUE #( ( %tky            = ls_header-%tky
                                      HideComplaints  = lv_hide_comp
                                      HideClaims      = lv_hide_clm
                                      Status          = lv_status
                                      TemplateContent = lv_template_content
                                      TemplateName    = lv_template_name
                                      TemplateMime    = lv_template_mime ) ).

        CATCH cx_root INTO DATA(lx_root).
          " Single COMBINED Modify for error!
          MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
                      ENTITY Migration UPDATE FIELDS ( HideComplaints HideClaims Status TemplateContent TemplateName TemplateMime )
                      WITH VALUE #( ( %tky            = ls_header-%tky
                                      HideComplaints  = lv_hide_comp
                                      HideClaims      = lv_hide_clm
                                      Status          = 'Error: Failed to parse Excel sheet.'
                                      TemplateContent = lv_template_content
                                      TemplateName    = lv_template_name
                                      TemplateMime    = lv_template_mime ) ).

      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

  METHOD executeMigration.

    READ ENTITIES OF zrefx_i_migration IN LOCAL MODE
    ENTITY Migration FIELDS ( TargetObject ) WITH CORRESPONDING #( keys ) RESULT DATA(lt_jobs)
    ENTITY Migration BY \_ComplaintsItems ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_comp_items)
    ENTITY Migration BY \_ClaimsItems ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_clm_items).

    LOOP AT lt_jobs INTO DATA(ls_job).

      CASE ls_job-TargetObject.
        WHEN '01'. " Complaints
          DATA lt_create_comp_target TYPE TABLE FOR CREATE zrefx_i_complaints.

          LOOP AT lt_comp_items INTO DATA(ls_comp) WHERE JobUuid = ls_job-JobUuid.
            APPEND VALUE #( %cid                = ls_comp-ItemUuid
                            Createddate         = ls_comp-Createddate
                            Status              = ls_comp-Status " (06)
                            Vendorid            = ls_comp-Vendorid
                            Vendorcompanyname   = ls_comp-Vendorcompanyname
                            Contactpersonname   = ls_comp-Contactpersonname
                            Contactmobile       = ls_comp-Contactmobile
                            Contactemail        = ls_comp-Contactemail
                            Legalflag           = ls_comp-Legalflag
                            Complaintcategory   = ls_comp-Complaintcategory
                            Sourcechannel       = ls_comp-Sourcechannel
                            Complainttype       = ls_comp-Complainttype
                            Urgency             = ls_comp-Urgency
                            Referencetype       = ls_comp-Referencetype
                            Referenceid         = ls_comp-Referenceid
                            Landid              = ls_comp-Landid
                            Titledeedno         = ls_comp-Titledeedno
                            Projectid           = ls_comp-Projectid
                            Claimreferenceno    = ls_comp-Claimreferenceno
                            Region              = ls_comp-Region
                            Detaileddescription = ls_comp-Detaileddescription
                            Financialimpact     = ls_comp-Financialimpact
                          ) TO lt_create_comp_target.
          ENDLOOP.

          IF lt_create_comp_target IS NOT INITIAL.
            MODIFY ENTITIES OF zrefx_i_complaints
              ENTITY Complaints CREATE FIELDS (
                 Status Vendorid Vendorcompanyname
                Contactpersonname Contactmobile Contactemail
                Complaintcategory Sourcechannel Complainttype Urgency
                Referencetype Referenceid Landid Titledeedno Projectid
                Claimreferenceno Region Detaileddescription Financialimpact
              ) WITH lt_create_comp_target.
          ENDIF.

          MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
            ENTITY ComplaintsItems DELETE FROM VALUE #( FOR comp_item IN lt_comp_items ( %tky = comp_item-%tky ) ).

        WHEN '02'. " Claims
          DATA lt_create_clm_target TYPE TABLE FOR CREATE zrefx_i_claims.

          LOOP AT lt_clm_items INTO DATA(ls_clm) WHERE JobUuid = ls_job-JobUuid.
            APPEND VALUE #( %cid                 = ls_clm-ItemUuid
                            Createddate          = ls_clm-Createddate
                            Status               = ls_clm-Status " (06)
                            Vendorid             = ls_clm-Vendorid
                            Contactpersonname    = ls_clm-Contactpersonname
                            Vendorregistrationno = ls_clm-Vendorregistrationno
                            Contactemail         = ls_clm-Contactemail
                            Claimcategory        = ls_clm-Claimcategory
                            Sourcechannel        = ls_clm-Sourcechannel
                            Claimtype            = ls_clm-Claimtype
                            Urgency              = ls_clm-Urgency
                            Referencetype        = ls_clm-Referencetype
                            Referenceid          = ls_clm-Referenceid
                            Leasenumber          = ls_clm-Leasenumber
                            Projectid            = ls_clm-Projectid
                            Projectname          = ls_clm-Projectname
                            Claimreferenceno     = ls_clm-Claimreferenceno
                            Region               = ls_clm-Region
                            City                 = ls_clm-City
                            Claimsubject         = ls_clm-Claimsubject
                            Incidentdate         = ls_clm-Incidentdate
                            Requestedpaymentdate = ls_clm-Requestedpaymentdate
                            Detaileddescription  = ls_clm-Detaileddescription
                            Claimamount          = ls_clm-Claimamount
                          ) TO lt_create_clm_target.
          ENDLOOP.

          IF lt_create_clm_target IS NOT INITIAL.
            MODIFY ENTITIES OF zrefx_i_claims
              ENTITY Claims CREATE FIELDS (
                Status Vendorid Contactpersonname
                Vendorregistrationno Contactemail Claimcategory Sourcechannel
                Claimtype Urgency Referencetype Referenceid Leasenumber
                Projectid Projectname Claimreferenceno Region City
                Claimsubject Incidentdate Requestedpaymentdate
                Detaileddescription Claimamount
              ) WITH lt_create_clm_target.
          ENDIF.

          MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
            ENTITY ClaimsItems DELETE FROM VALUE #( FOR clm_item IN lt_clm_items ( %tky = clm_item-%tky ) ).
      ENDCASE.

      " Final Header Update
      MODIFY ENTITIES OF zrefx_i_migration IN LOCAL MODE
        ENTITY Migration UPDATE FIELDS ( Status FileContent MimeType FileName TemplateContent TemplateMime TemplateName )
        WITH VALUE #( ( %tky = ls_job-%tky
                        Status          = 'Migrated Successfully'
                        FileContent     = ''
                        MimeType        = ''
                        FileName        = ''
                        TemplateContent = ''
                        TemplateName    = ''
                        TemplateMime    = '' ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
