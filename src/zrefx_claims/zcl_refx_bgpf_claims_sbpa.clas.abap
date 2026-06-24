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
*        CreatedBy             TYPE zrefx_i_claims-c                      OPTIONAL
        CreatedDate   TYPE zrefx_i_claims-Createddate            OPTIONAL.





    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single .

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES: BEGIN OF ty_claim_data,
*             claimid      TYPE string,
*             claim_type   TYPE string,
*             claim_ref_no TYPE string,
*             claim_amount TYPE p LENGTH 15 DECIMALS 2,
             Claimid       TYPE string,
             Claimtype     TYPE string,
             Claimcategory TYPE string,
             SourceChannel TYPE string,
             Claimsubject  TYPE string,
             Claimamount   TYPE string,
             Description   TYPE string,
             Status        TYPE string,
             "CreatedBy           TYPE string,
             CreatedDate   TYPE string,
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
*      definition_id = 'sa30.sec-rs-dev-6durkmdm.re04acomplaintmanagementprocess.complaintApprovalProcess' " Found in SBPA Monitoring
       definition_id =  'sa30.sec-rs-dev-6durkmdm.re05newclaimmanagement.claimProcess'
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
        "CreatedBy            = gs_context-"CreatedBy   .
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


*                        ( abap = 'CONTEXT'       json = 'context' )
*                        ( abap = 'CLAIMID'       json = 'claim_id' )
*                        ( abap = 'CLAIM_TYPE'    json = 'claim_type' )
*                        ( abap = 'CLAIM_REF_NO'  json = 'claim_ref_no' )
*                        ( abap = 'CLAIM_AMOUNT'  json = 'claim_amount' )

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
                        ( abap = 'CREATEDDATE'   json = 'CreatedDate' )
                      )
    ).

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
          i_name       = 'sap_process_automation_service' ). "Found in SAP BTP Destinations

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = lo_destination ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        lo_request->set_header_field( i_name = 'irpa-api-key' i_value = 'tIz4x-XPQyPltaI8jA5wf3LEuL-wPFaU' ). "i_value = 'SS2n8TwUGgvznptjvpM5QK1HkW9oUMTS' ).
        lo_request->set_uri_path( '/workflow/rest/v1/workflow-instances' ). ""check in BPA payload URL path
        lo_request->set_query( query = 'environmentId=sbpatestforallprocess' ). "'environmentId=realestate' ). "check in BPA payload URL path
        lo_request->set_text( lv_json ).

        DATA(lo_response) = lo_http_client->execute( if_web_http_client=>post ).

        DATA(lv_status) = lo_response->get_status( ).

        IF lv_status-code NE 200 AND lv_status-code NE 201.
          DATA(lv_response_body) = lo_response->get_text( ).
          " Log warning
        ENDIF.

      CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
        " Log - do not abort

      CATCH cx_web_http_client_error INTO DATA(lx_http).
        " Log - do not abort

    ENDTRY.

  ENDMETHOD.


  METHOD set_context_data.
*    gs_context-claimid          = claimid.
*    gs_context-claim_type       = claim_type.
*    gs_context-claim_ref_no     = claim_ref_no.
*    gs_context-claim_amount     = claim_amount.

    gs_context-Claimid       = claimid.
    gs_context-claimtype     = claimtype.
    gs_context-claimcategory = claimcategory.
    gs_context-sourcechannel = sourcechannel.
    gs_context-claimsubject  = claimsubject.
    gs_context-claimamount   = claimamount.
    gs_context-description   = description.
    gs_context-status        = status.
    "gs_context-"CreatedBy   .
    gs_context-createddate   = createddate.

  ENDMETHOD.
ENDCLASS.
