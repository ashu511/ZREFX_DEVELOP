

CLASS zcl_refx_bgpf_compns_sbpa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS set_context_data
      IMPORTING
        CompensationId       TYPE zrefx_i_compensation-CompensationId              OPTIONAL
        Compensationtype     TYPE zrefx_i_compensation-Compensationtype             OPTIONAL
        Compensationcategory TYPE zrefx_i_compensation-Compensationcategory          OPTIONAL
        SourceChannel        TYPE zrefx_i_compensation-Sourcechannel          OPTIONAL
        Compensationsubject  TYPE zrefx_i_compensation-Compnssubject           OPTIONAL
        Compensationamount   TYPE zrefx_i_compensation-Compensationamount            OPTIONAL
        Description          TYPE zrefx_i_compensation-Detaileddescription    OPTIONAL
        Status               TYPE zrefx_i_compensation-Status                 OPTIONAL
*        CreatedBy     TYPE string OPTIONAL
*        CreatedDate   TYPE zrefx_i_compensation-Createddate            OPTIONAL
        SubmittedBy          TYPE string OPTIONAL
        SubmittedOn          TYPE zrefx_i_compensation-Createddate            OPTIONAL
        landid               TYPE zrefx_i_complaints-Landid             OPTIONAL
        vendoremail          TYPE zrefx_i_complaints-Contactemail       OPTIONAL
        vendorname_en        TYPE zrefx_i_complaints-Vendorname         OPTIONAL
        vendorname_ar        TYPE zrefx_i_complaints-Vendorname         OPTIONAL
        titledeed            TYPE zrefx_i_complaints-Titledeedno        OPTIONAL.


    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single .

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES: BEGIN OF ty_Compensation_data,

             CompensationId       TYPE string,
             Compensationtype     TYPE string,
             Compensationcategory TYPE string,
             SourceChannel        TYPE string,
             Compensationsubject  TYPE string,
             Compensationamount   TYPE string,
             Description          TYPE string,
             Status               TYPE string,
*             CreatedBy     TYPE string,
*             CreatedDate   TYPE string,
             SubmittedBy          TYPE string,
             SubmittedOn          TYPE string,
             landid               TYPE string,
             titledeed            TYPE string,
             vendoremail          TYPE string,
             vendorname_en        TYPE string,
             vendorname_ar        TYPE string,
           END OF ty_Compensation_data,

           BEGIN OF ty_context_wrapper,
             compensationData TYPE ty_Compensation_data,
           END OF ty_context_wrapper,

           BEGIN OF ty_sbpa_payload,
             definition_id TYPE string,
             context       TYPE ty_context_wrapper,
           END OF ty_sbpa_payload.

    DATA: gs_context TYPE ty_Compensation_data.

ENDCLASS.



CLASS zcl_refx_bgpf_compns_sbpa IMPLEMENTATION.


  METHOD if_bgmc_op_single~execute.
    " =======================================================================
    " GET DYNAMIC CONFIGURATION (INJECT SINGLETON)
    " =======================================================================
    DATA(lo_config) = zcl_refx_comp_config=>get_instance( ).

    DATA(lv_btp_dest)  = lo_config->get_sbpa_destination( ).
    DATA(lv_wf_def)    = lo_config->get_wf_definition_id( ).
    DATA(lv_api_key)   = lo_config->get_sbpa_api_key( ).
    DATA(lv_env_id)    = lo_config->get_wf_environment_id( ).
    DATA(lv_inbox_url) = lo_config->get_sbpa_inbox_url( ).
    " =======================================================================
    " ENHANCE CONTEXT WITH BILINGUAL CATEGORY DESCRIPTION
    " =======================================================================
    DATA: lv_desc_en        TYPE string,
          lv_desc_ar        TYPE string,
          lv_bilingual_desc TYPE string.

    CLEAR: lv_desc_en, lv_desc_ar, lv_bilingual_desc.

    " Get English Description ('E')
    SELECT SINGLE text FROM ddcds_customer_domain_value_t( p_domain_name = 'ZREFX_DO_CLAIMCAT' )
      WHERE value_low = @gs_context-compensationcategory AND language = 'E'
      INTO @lv_desc_en.

    " Get Arabic Description ('A')
    SELECT SINGLE text FROM ddcds_customer_domain_value_t( p_domain_name = 'ZREFX_DO_CLAIMCAT' )
      WHERE value_low = @gs_context-compensationcategory AND language = 'A'
      INTO @lv_desc_ar.

    " Combine them with a pipe. Fallback to raw code if missing.
    IF lv_desc_en IS NOT INITIAL AND lv_desc_ar IS NOT INITIAL.
      lv_bilingual_desc = |{ lv_desc_en } \| { lv_desc_ar }|.
    ELSEIF lv_desc_en IS NOT INITIAL.
      lv_bilingual_desc = lv_desc_en.
    ELSEIF lv_desc_ar IS NOT INITIAL.
      lv_bilingual_desc = lv_desc_ar.
    ELSE.
      lv_bilingual_desc = gs_context-compensationcategory. " Fallback to raw ID
    ENDIF.

    " OVERWRITE the raw code in the context with the new bilingual string
    " before it gets serialized into JSON!
    gs_context-compensationcategory = lv_bilingual_desc.
    " =======================================================================

    DATA(ls_payload) = VALUE ty_sbpa_payload(
*       definition_id = 'sa30.sec-rs-dev-6durkmdm.re04acomplaintmanagementprocess.complaintApprovalProcess' " Found in SBPA Monitoring
*       definition_id = 'sa30.sec-rs-dev-6durkmdm.re05newclaimmanagement.claimProcess'
*        definition_id = 'sa30.sec-rs-dev-6durkmdm.re05newclaimmanagement1.claimProcess'
        definition_id = lv_wf_def

       context = VALUE ty_context_wrapper(
        compensationData = VALUE ty_compensation_data(
*        claimid         = gs_context-claimid
*        claim_type      = gs_context-claim_type
*        claim_ref_no    = gs_context-claim_ref_no
*        claim_amount    = gs_context-claim_amount
        compensationid          = gs_context-compensationid
         Compensationtype        = gs_context-Compensationtype
         Compensationcategory    = gs_context-Compensationcategory

        SourceChannel    = gs_context-SourceChannel
        Compensationsubject     = gs_context-compensationsubject
        Compensationamount      = gs_context-compensationamount
        Description      = gs_context-Description
        Status           = gs_context-Status
        landid           = gs_context-landid
        titledeed        = gs_context-titledeed
        vendoremail      = gs_context-vendoremail
        vendorname_ar    = gs_context-vendorname_ar
        vendorname_en    = gs_context-vendorname_en
*        submittedby      = gs_context-submittedby
*        createdby        =  gs_context-createdby
*        CreatedDate      = gs_context-CreatedDate
         SubmittedBy  =  gs_context-submittedby
         SubmittedOn  =  gs_context-submittedon

       )
      )
    ).

    "Serialize to JSON (camelCase + PascalCase)
    DATA(lv_json) = /ui2/cl_json=>serialize(
      data          = ls_payload
      compress      = abap_true
      pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
      name_mappings = VALUE /ui2/cl_json=>name_mappings(


                        ( abap = 'CONTEXT'       json = 'context' )
                        ( abap = 'COMPENSATIONData'     json = 'compensationData' )
                        ( abap = 'COMPENSATIONID'       json = 'Compensationid' )
                        ( abap = 'COMPENSATIONTYPE'     json = 'Compensationtype' )
                        ( abap = 'COMPENSATIONCATEGORY' json = 'Compensationcategory' )
                        ( abap = 'SOURCECHANNEL' json = 'SourceChannel' )

                        ( abap = 'COMPENSATIONSUBJECT'  json = 'Compensationsubject' )
                        ( abap = 'COMPENSATIONAMOUNT'   json = 'Compensationamount' )
                        ( abap = 'DESCRIPTION'   json = 'Description' )
                        ( abap = 'STATUS'        json = 'Status' )
*                        ( abap = 'CREATEDBY'     json = 'CreatedBy' )
*                        ( abap = 'CREATEDDATE'   json = 'CreatedDate' )
                        ( abap = 'SUBMITTEDBY'  json = 'SubmittedBy' )
                        ( abap = 'SUBMITTEDON'  json = 'SubmittedOn' )
                        ( abap = 'VENDOREMAIL'   json = 'vendorEmail' )
                        ( abap = 'VENDORNAME_EN' json = 'vendorName_en' )
                        ( abap = 'VENDORNAME_AR' json = 'vendorName_ar' )
                        ( abap = 'LANDID'        json = 'LandId' )
                        ( abap = 'TITLEDEED'     json = 'TitleDeed' )
                      )
    ).

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
*          i_name       = 'sap_process_automation_service' ). "Found in SAP BTP Destinations
       i_name = lv_btp_dest ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = lo_destination ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
*       lo_request->set_header_field( i_name = 'irpa-api-key' i_value = 'bRxySNt3ahOYqHKszaT0cSgKWVCgb4lE' ).
        lo_request->set_header_field( i_name = 'irpa-api-key' i_value = lv_api_key ).

        lo_request->set_uri_path( '/workflow/rest/v1/workflow-instances' ). ""check in BPA payload URL path

*        lo_request->set_query( query =  'environmentId=newrealestate' ). "'environmentId=sbpatestforallprocess' ). "'environmentId=realestate' ). "check in BPA payload URL path
        DATA(lv_query_string) = |environmentId={ lv_env_id }|.
        lo_request->set_query( query = lv_query_string ).

        lo_request->set_text( lv_json ).

        DATA(lo_response) = lo_http_client->execute( if_web_http_client=>post ).

        DATA(lv_status) = lo_response->get_status( ).
        DATA(lv_response_body) = lo_response->get_text( ).
*--------------------------------------------------------------------------*
* Success
*--------------------------------------------------------------------------*
        IF lv_status-code = 200 OR lv_status-code = 201 OR lv_status-code = 202.

          " Define a structure matching the exact SBPA JSON payload keys you provided
          TYPES: BEGIN OF ty_sbpa_response,
                   id     TYPE string,
                   status TYPE string,
                 END OF ty_sbpa_response.
          DATA ls_response TYPE ty_sbpa_response.

          " Deserialize the JSON string into the ABAP structure
          /ui2/cl_json=>deserialize(
            EXPORTING json = lv_response_body
            CHANGING  data = ls_response
          ).

          " If we successfully extracted the Instance ID, write the first log entry
          IF ls_response-id IS NOT INITIAL.

            MODIFY ENTITIES OF zrefx_i_compensation
              ENTITY zrefx_i_compensation
*                EXECUTE SetStatusSubmitted FROM VALUE #( ( Claimid = gs_context-claimid ) )
                CREATE BY \_WorkflowInfo
                FIELDS ( ApprovalStep ApprovalStepDesc WfInstanceId CurrentStatus CurrentOwner SubmissionFromDate )
                WITH VALUE #( ( CompensationId = gs_context-compensationid
                                %target = VALUE #( ( %cid               = 'INIT_WF'
                                                     ApprovalStep       = '0'
                                                     ApprovalStepDesc   = 'TRIGGERED'
                                                     WfInstanceId       = ls_response-id
                                                     " You can map 'RUNNING' directly or hardcode 'SUBMITTED'
                                                     CurrentStatus      = 'SUBMITTED'
                                                     CurrentOwner       = gs_context-submittedby
                                                     SubmissionFromDate = cl_abap_context_info=>get_system_date( ) ) ) ) )
              REPORTED DATA(ls_reported)
              FAILED DATA(ls_failed).

          ENDIF.

        ELSE.
          " Optional: Handle non-200 responses (e.g., write to application log / SLG1)
        ENDIF.



      CATCH cx_http_dest_provider_error INTO DATA(lx_dest)  ##NO_HANDLER.
        " Log - do not abort

      CATCH cx_web_http_client_error INTO DATA(lx_http)  ##NO_HANDLER.
        " Log - do not abort

    ENDTRY.

  ENDMETHOD.


  METHOD set_context_data.

    gs_context-compensationid       = compensationid.
    gs_context-compensationtype     = compensationtype.
    gs_context-compensationcategory = compensationcategory.
    gs_context-sourcechannel = sourcechannel.
    gs_context-compensationsubject  = compensationsubject.
    gs_context-compensationamount   = compensationamount.
    gs_context-description   = description.
    gs_context-status        = 'SUBMITTED'.    "status.
    "gs_context-"CreatedBy   .
*    gs_context-createdby     = createdby.
*    gs_context-createddate   = createddate.
    gs_context-submittedby    = submittedby.
    gs_context-submittedon    = submittedon.
    gs_context-landid        = landid.

    IF gs_context-submittedon IS NOT INITIAL AND strlen( gs_context-submittedon ) = 8.
      DATA(lv_formatted_date) = |{ gs_context-submittedon+6(2) }.{ gs_context-submittedon+4(2) }.{ gs_context-submittedon(4) }|.
      gs_context-submittedon = lv_formatted_date.
    ENDIF.

    gs_context-titledeed            = titledeed.
    gs_context-vendoremail          = vendoremail.
    gs_context-vendorname_ar        = vendorname_ar.
    gs_context-vendorname_en        = vendorname_en.


  ENDMETHOD.
ENDCLASS.
