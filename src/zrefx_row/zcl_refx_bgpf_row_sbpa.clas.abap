CLASS zcl_refx_bgpf_row_sbpa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS set_context_data
      IMPORTING requestid   TYPE zrefx_i_row_request-RequestId
                submittedby TYPE zrefx_i_row_request-Currentprocessoruser OPTIONAL.

    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single .

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES: BEGIN OF ty_context_data,
             row_id    TYPE string,
             inbox_url TYPE string,
           END OF ty_context_data,

           BEGIN OF ty_sbpa_payload,
             definition_id TYPE string,

             context       TYPE ty_context_data,
           END OF ty_sbpa_payload.

    DATA: gs_context     TYPE ty_context_data,
          mv_requestid   TYPE string,
          mv_submittedby TYPE string.

ENDCLASS.



CLASS zcl_refx_bgpf_row_sbpa IMPLEMENTATION.

  METHOD if_bgmc_op_single~execute.
    " =======================================================================
    " GET DYNAMIC CONFIGURATION (INJECT SINGLETON)
    " =======================================================================
    DATA(lo_config) = zcl_refx_row_config=>get_instance( ).

    DATA(lv_btp_dest)  = lo_config->get_sbpa_destination( ).
    DATA(lv_wf_def)    = lo_config->get_wf_definition_id( ).
    DATA(lv_api_key)   = lo_config->get_sbpa_api_key( ).
    DATA(lv_env_id)    = lo_config->get_wf_environment_id( ).
    DATA(lv_inbox_url) = lo_config->get_sbpa_inbox_url( ).
    " Insert Inbox URL to SBPA Context
    gs_context-inbox_url = lv_inbox_url.
    " =======================================================================
    " 1. BUILD SBPA JSON PAYLOAD
    " =======================================================================
    DATA(ls_payload) = VALUE ty_sbpa_payload(
      definition_id = lv_wf_def "'sa30.sec-rs-dev-6durkmdm.re06rightofwayprocess.rightOfWayProcess'
      context       = gs_context
    ).
    " Serialize to JSON exactly like the Complaints app
    DATA(lv_json) = /ui2/cl_json=>serialize(
      data          = ls_payload
      compress      = abap_true
      pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
      name_mappings = VALUE /ui2/cl_json=>name_mappings(
                        ( abap = 'ROW_ID' json = 'row_id' )
                      )
    ).

    " =======================================================================
    " 2. EXECUTE HTTP CALL TO SBPA
    " =======================================================================
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
          i_name = 'sap_process_automation_service' ). " Same BTP Dest as Complaints

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = lo_destination ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        " Using the exact API key and URI from your Complaints reference
*        lo_request->set_header_field( i_name = 'irpa-api-key' i_value = 'bRxySNt3ahOYqHKszaT0cSgKWVCgb4lE' ).
        lo_request->set_header_field( i_name = 'irpa-api-key' i_value = lv_api_key ).
        lo_request->set_uri_path( '/workflow/rest/v1/workflow-instances' ).
*        lo_request->set_query( query = 'environmentId=newrealestate' ). " Exact environment ID
        DATA(lv_query_string) = |environmentId={ lv_env_id }|.
        lo_request->set_query( query = lv_query_string ).

        lo_request->set_text( lv_json ).

        DATA(lo_response) = lo_http_client->execute( if_web_http_client=>post ).
        DATA(lv_status) = lo_response->get_status( ).
        DATA(lv_response_body) = lo_response->get_text( ).

        " =======================================================================
        " 3. HANDLE RESPONSE AND UPDATE RAP WORKFLOW LOG
        " =======================================================================
        IF lv_status-code = 200 OR lv_status-code = 201 OR lv_status-code = 202.

          " Define a structure matching the SBPA JSON response payload
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

            " Use RAP EML (Local Mode) to insert the log into zrefx_gl_workin.
            " adjust_numbers will automatically generate the 'Objectid' UUID!
*            MODIFY ENTITIES OF zrefx_i_row_request
*                 ENTITY Row
*                   CREATE BY \_WorkflowInstance
*                   FIELDS ( ApprovalStep ApprovalStepDesc WfInstanceId CurrentStatus CurrentOwner SubmissionDate )
*                   WITH VALUE #( ( RequestId = mv_requestid
*                                   %target = VALUE #( ( %cid               = 'INIT_GL_WF'
*                                                        ApprovalStep       = '0'
*                                                        ApprovalStepDesc   = 'TRIGGERED'
*                                                        WfInstanceId       = ls_response-id
*                                                        CurrentStatus      = 'SUBMITTED'
*                                                        CurrentOwner       = mv_submittedby
*                                                        SubmissionDate = cl_abap_context_info=>get_system_date( ) ) ) ) )
*                 REPORTED DATA(ls_reported)
*                 FAILED DATA(ls_failed).

*            IF ls_failed IS INITIAL.
*              " Background process handles COMMIT automatically
*            ENDIF.

          ENDIF.

        ELSE.
          " Handle non-200 responses (e.g., write to SLG1)
        ENDIF.

      CATCH cx_http_dest_provider_error INTO DATA(lx_dest) ##NO_HANDLER.
      CATCH cx_web_http_client_error INTO DATA(lx_http) ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.


  METHOD set_context_data.
    mv_requestid      = requestid.
    mv_submittedby    = submittedby.
    gs_context-row_id = requestid.
  ENDMETHOD.

ENDCLASS.
