CLASS zcl_refx_bgpf_claims_sbpa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS set_context_data
*      IMPORTING claimid      TYPE zrefx_i_claims-Claimid          OPTIONAL
*                claim_type   TYPE zrefx_i_claims-Claimtype        OPTIONAL
*                claim_ref_no TYPE zrefx_i_claims-Claimreferenceno OPTIONAL
*                claim_amount TYPE zrefx_i_claims-Claimamount      OPTIONAL.


      IMPORTING "claimData TYPE zrefx_i_claims-Claim          OPTIONAL
        Claimid       TYPE zrefx_i_claims-Claimid                OPTIONAL
        Claimtype     TYPE zrefx_i_claims-Claimtype              OPTIONAL
        Claimcategory TYPE zrefx_i_claims-Claimcategory          OPTIONAL
        SourceChannel TYPE zrefx_i_claims-Sourcechannel          OPTIONAL
        Claimsubject  TYPE zrefx_i_claims-Claimsubject           OPTIONAL
        Claimamount   TYPE zrefx_i_claims-Claimamount            OPTIONAL
        Description   TYPE zrefx_i_claims-Detaileddescription    OPTIONAL
        Status        TYPE zrefx_i_claims-Status                 OPTIONAL
        CreatedBy     TYPE string OPTIONAL
*        submittedby   TYPE string OPTIONAL
        CreatedDate   TYPE zrefx_i_claims-Createddate            OPTIONAL

        landid        TYPE zrefx_i_complaints-Landid             OPTIONAL
        vendoremail   TYPE zrefx_i_complaints-Contactemail       OPTIONAL
        vendorname_en TYPE zrefx_i_complaints-Vendorname         OPTIONAL
        vendorname_ar TYPE zrefx_i_complaints-Vendorname         OPTIONAL
        titledeed     TYPE zrefx_i_complaints-Titledeedno        OPTIONAL.


    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single .

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES: BEGIN OF ty_claim_data,

             Claimid       TYPE string,
             Claimtype     TYPE string,
             Claimcategory TYPE string,
             SourceChannel TYPE string,
             Claimsubject  TYPE string,
             Claimamount   TYPE string,
             Description   TYPE string,
             Status        TYPE string,
             CreatedBy     TYPE string,
*             submittedby   TYPE string,
             CreatedDate   TYPE string,
             landid        TYPE string,
             titledeed     TYPE string,
             vendoremail   TYPE string,
             vendorname_en TYPE string,
             vendorname_ar TYPE string,
           END OF ty_claim_data,

           BEGIN OF ty_context_wrapper,
             claimData TYPE ty_claim_data,
           END OF ty_context_wrapper,

           BEGIN OF ty_sbpa_payload,
             definition_id TYPE string,
             context       TYPE ty_context_wrapper,
           END OF ty_sbpa_payload.

    DATA: gs_context TYPE ty_claim_data.

ENDCLASS.



CLASS zcl_refx_bgpf_claims_sbpa IMPLEMENTATION.


  METHOD if_bgmc_op_single~execute.

    DATA(ls_payload) = VALUE ty_sbpa_payload(
*       definition_id = 'sa30.sec-rs-dev-6durkmdm.re04acomplaintmanagementprocess.complaintApprovalProcess' " Found in SBPA Monitoring
*       definition_id = 'sa30.sec-rs-dev-6durkmdm.re05newclaimmanagement.claimProcess'
        definition_id = 'sa30.sec-rs-dev-6durkmdm.re05newclaimmanagement1.claimProcess'
       context = VALUE ty_context_wrapper(
        claimData = VALUE ty_claim_data(
*        claimid         = gs_context-claimid
*        claim_type      = gs_context-claim_type
*        claim_ref_no    = gs_context-claim_ref_no
*        claim_amount    = gs_context-claim_amount
        Claimid          = gs_context-Claimid
        Claimtype        = gs_context-Claimtype
        Claimcategory    = gs_context-Claimcategory
        SourceChannel    = gs_context-SourceChannel
        Claimsubject     = gs_context-Claimsubject
        Claimamount      = gs_context-Claimamount
        Description      = gs_context-Description
        Status           = gs_context-Status
        landid           = gs_context-landid
        titledeed        = gs_context-titledeed
        vendoremail      = gs_context-vendoremail
        vendorname_ar    = gs_context-vendorname_ar
        vendorname_en    = gs_context-vendorname_en
*        submittedby      = gs_context-submittedby
        createdby        =  gs_context-createdby
        CreatedDate      = gs_context-CreatedDate
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
                        ( abap = 'CLAIMDATA'     json = 'claimData' )
                        ( abap = 'CLAIMID'       json = 'Claimid' )
                        ( abap = 'CLAIMTYPE'     json = 'Claimtype' )
                        ( abap = 'CLAIMCATEGORY' json = 'Claimcategory' )
                        ( abap = 'SOURCECHANNEL' json = 'SourceChannel' )

                        ( abap = 'CLAIMSUBJECT'  json = 'Claimsubject' )
                        ( abap = 'CLAIMAMOUNT'   json = 'Claimamount' )
                        ( abap = 'DESCRIPTION'   json = 'Description' )
                        ( abap = 'STATUS'        json = 'Status' )
                        ( abap = 'CREATEDBY'     json = 'CreatedBy' )
*                        ( abap = 'SUBMITTEDBY'  json = 'SubmittedBy' )
                        ( abap = 'CREATEDDATE'   json = 'CreatedDate' )
                        ( abap = 'VENDOREMAIL'   json = 'vendorEmail' )
                        ( abap = 'VENDORNAME_EN' json = 'vendorName_en' )
                        ( abap = 'VENDORNAME_AR' json = 'vendorName_ar' )
                        ( abap = 'LANDID'        json = 'LandId' )
                        ( abap = 'TITLEDEED'     json = 'TitleDeed' )
                      )
    ).

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
          i_name       = 'sap_process_automation_service' ). "Found in SAP BTP Destinations

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = lo_destination ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        lo_request->set_header_field( i_name = 'irpa-api-key' i_value = 'bRxySNt3ahOYqHKszaT0cSgKWVCgb4lE' ).
        lo_request->set_uri_path( '/workflow/rest/v1/workflow-instances' ). ""check in BPA payload URL path
        lo_request->set_query( query =  'environmentId=newrealestate' ). "'environmentId=sbpatestforallprocess' ). "'environmentId=realestate' ). "check in BPA payload URL path
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

            MODIFY ENTITIES OF zrefx_i_claims
              ENTITY claims
                EXECUTE SetStatusSubmitted FROM VALUE #( ( Claimid = gs_context-claimid ) )
                CREATE BY \_WorkflowInfo
                FIELDS ( ApprovalStep ApprovalStepDesc WfInstanceId CurrentStatus CurrentOwner SubmissionFromDate )
                WITH VALUE #( ( Claimid = gs_context-claimid
                                %target = VALUE #( ( %cid               = 'INIT_WF'
                                                     ApprovalStep       = '0'
                                                     ApprovalStepDesc   = 'TRIGGERED'
                                                     WfInstanceId       = ls_response-id
                                                     " You can map 'RUNNING' directly or hardcode 'SUBMITTED'
                                                     CurrentStatus      = 'SUBMITTED'
                                                     CurrentOwner       = gs_context-createdby
                                                     SubmissionFromDate = cl_abap_context_info=>get_system_date( ) ) ) ) )
              REPORTED DATA(ls_reported)
              FAILED DATA(ls_failed).

          ENDIF.

        ELSE.
          " Optional: Handle non-200 responses (e.g., write to application log / SLG1)
        ENDIF.



      CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
        " Log - do not abort

      CATCH cx_web_http_client_error INTO DATA(lx_http).
        " Log - do not abort

    ENDTRY.

  ENDMETHOD.


  METHOD set_context_data.

    gs_context-Claimid       = claimid.
    gs_context-claimtype     = claimtype.
    gs_context-claimcategory = claimcategory.
    gs_context-sourcechannel = sourcechannel.
    gs_context-claimsubject  = claimsubject.
    gs_context-claimamount   = claimamount.
    gs_context-description   = description.
    gs_context-status        = 'SUBMITTED'.    "status.
    "gs_context-"CreatedBy   .
    gs_context-createdby     = createdby.
    gs_context-createddate   = createddate.
    gs_context-landid        = landid.

    IF gs_context-createddate IS NOT INITIAL AND strlen( gs_context-createddate ) = 8.
      DATA(lv_formatted_date) = |{ gs_context-createddate+6(2) }.{ gs_context-createddate+4(2) }.{ gs_context-createddate(4) }|.
      gs_context-createddate = lv_formatted_date.
    ENDIF.

    gs_context-titledeed            = titledeed.
    gs_context-vendoremail          = vendoremail.
    gs_context-vendorname_ar        = vendorname_ar.
    gs_context-vendorname_en        = vendorname_en.


  ENDMETHOD.
ENDCLASS.
