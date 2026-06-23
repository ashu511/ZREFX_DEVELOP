CLASS zcl_refx_bgpf_complaints_sbpa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS set_context_data
*      IMPORTING complaintid     TYPE zrefx_i_complaints-ComplaintId OPTIONAL
*                complaintnumber TYPE zrefx_i_complaints-ComplaintId OPTIONAL
*                categorycode    TYPE zrefx_i_complaints-Complaintcategory OPTIONAL
*                description     TYPE zrefx_i_complaints-Detaileddescription
*                createdby       TYPE string OPTIONAL
*                createdat       TYPE zrefx_i_complaints-Createddate OPTIONAL.
      IMPORTING complaintid          TYPE zrefx_i_complaints-ComplaintId OPTIONAL
                categorycode         TYPE zrefx_i_complaints-Complaintcategory OPTIONAL
                description          TYPE zrefx_i_complaints-Detaileddescription OPTIONAL
                landid               TYPE zrefx_i_complaints-Landid OPTIONAL
                titledeed            TYPE zrefx_i_complaints-Titledeedno OPTIONAL
                sourcechannel        TYPE zrefx_i_complaints-Sourcechannel OPTIONAL
                status               TYPE zrefx_i_complaints-Status OPTIONAL
                submittedon          TYPE zrefx_i_complaints-Createddate OPTIONAL
                complainant          TYPE zrefx_i_complaints-Vendorname OPTIONAL
                requestorowner       TYPE string OPTIONAL
                maindvmorgunit       TYPE zrefx_i_complaints-MainDivision OPTIONAL
                isgovernmentinvolved TYPE abap_bool OPTIONAL
                requireslegal        TYPE abap_bool OPTIONAL
                vendoremail          TYPE zrefx_i_complaints-Contactemail OPTIONAL
                vendorname_en        TYPE zrefx_i_complaints-Vendorname OPTIONAL
                vendorname_ar        TYPE zrefx_i_complaints-Vendorname OPTIONAL
                submittedby          TYPE string OPTIONAL
                complaintype         TYPE zrefx_i_complaints-Complainttype OPTIONAL.

    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single .

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES: BEGIN OF ty_context_data,
*             complaintid     TYPE string,
*             complaintnumber TYPE string,
*             categorycode    TYPE string,
*             description     TYPE string,
*             createdby       TYPE string,
*             createdat       TYPE string,
             complaintid          TYPE string,
             categorycode         TYPE string,
             description          TYPE string,
             landid               TYPE string,
             titledeed            TYPE string,
             sourcechannel        TYPE string,
             status               TYPE string,
             submittedon          TYPE string,
             complainant          TYPE string,
             requestorowner       TYPE string,
             maindvmorgunit       TYPE string,
             isgovernmentinvolved TYPE abap_bool,
             requireslegal        TYPE abap_bool,
             vendoremail          TYPE string,
             vendorname_en        TYPE string,
             vendorname_ar        TYPE string,
             submittedby          TYPE string,
             complantype          TYPE string,
           END OF ty_context_data,

           BEGIN OF ty_complaint_wrapper,
             complaint_context TYPE ty_context_data,
           END OF ty_complaint_wrapper,

           BEGIN OF ty_sbpa_payload,
             definition_id TYPE string,
             context       TYPE ty_complaint_wrapper,
           END OF ty_sbpa_payload.

    DATA: gs_context TYPE ty_context_data.

ENDCLASS.



CLASS zcl_refx_bgpf_complaints_sbpa IMPLEMENTATION.


  METHOD if_bgmc_op_single~execute.

    DATA(ls_payload) = VALUE ty_sbpa_payload(
**      definition_id = 'sa30.sec-rs-dev-6durkmdm.re04acomplaintmanagementprocess.complaintApprovalProcess' " Found in SBPA Monitoring
*      definition_id = 'sa30.sec-rs-dev-6durkmdm.re04acomplaintmanagementprocess.complaintProcess' " Found in SBPA Monitoring
      definition_id = 'sa30.sec-rs-dev-6durkmdm.re04newcomplaintmanagement.complaintProcess' " Found in SBPA Monitoring
      context-complaint_context = gs_context
*      context-complaint_context = VALUE ty_context_data(
*        complaintid     = gs_context-ComplaintId
*        complaintnumber = gs_context-ComplaintId
*        categorycode    = gs_context-Categorycode
*        description     = gs_context-Description
*        createdby       = gs_context-createdby
*        createdat       = gs_context-createdat
*      )
    ).

    "Serialize to JSON (camelCase + PascalCase)
    DATA(lv_json) = /ui2/cl_json=>serialize(
      data          = ls_payload
      compress      = abap_true
      pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
      name_mappings = VALUE /ui2/cl_json=>name_mappings(
*                        ( abap = 'COMPLAINT_CONTEXT' json = 'ComplaintContext' )
*                        ( abap = 'COMPLAINTID'       json = 'Complaintid' )
*                        ( abap = 'COMPLAINTNUMBER'   json = 'Complaintnumber' )
*                        ( abap = 'CATEGORYCODE'      json = 'Categorycode' )
*                        ( abap = 'DESCRIPTION'       json = 'Description' )
*                        ( abap = 'CREATEDBY'         json = 'Createdby' )
*                        ( abap = 'CREATEDAT'         json = 'Createdat' )
                        ( abap = 'COMPLAINT_CONTEXT'    json = 'ComplaintContext' )
                        ( abap = 'COMPLAINTID'          json = 'Complaintid' )
                        ( abap = 'CATEGORYCODE'         json = 'Categorycode' )
                        ( abap = 'DESCRIPTION'          json = 'Description' )
                        ( abap = 'LANDID'               json = 'LandId' )
                        ( abap = 'TITLEDEED'            json = 'TitleDeed' )
                        ( abap = 'SOURCECHANNEL'        json = 'SourceChannel' )
                        ( abap = 'STATUS'               json = 'Status' )
                        ( abap = 'SUBMITTEDON'          json = 'SubmittedOn' )
                        ( abap = 'COMPLAINANT'          json = 'Complainant' )
                        ( abap = 'REQUESTOROWNER'       json = 'RequestorOwner' )
                        ( abap = 'MAINDVMORGUNIT'       json = 'MainDvmOrgUnit' )
                        ( abap = 'ISGOVERNMENTINVOLVED' json = 'IsGovernmentInvolved' )
                        ( abap = 'REQUIRESLEGAL'        json = 'RequiresLegal' )
                        ( abap = 'VENDOREMAIL'          json = 'vendorEmail' )
                        ( abap = 'VENDORNAME_EN'        json = 'vendorName_en' )
                        ( abap = 'VENDORNAME_AR'        json = 'vendorName_ar' )
                        ( abap = 'SUBMITTEDBY'          json = 'SubmittedBy' )
                        ( abap = 'COMPLANTYPE'          json = 'ComplanType' )
                      )
    ).

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
          i_name       = 'sap_process_automation_service' ). "Found in SAP BTP Destinations

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = lo_destination ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
*        lo_request->set_header_field( i_name = 'irpa-api-key' i_value = 'SS2n8TwUGgvznptjvpM5QK1HkW9oUMTS' ).
        lo_request->set_header_field( i_name = 'irpa-api-key' i_value = 'tIz4x-XPQyPltaI8jA5wf3LEuL-wPFaU' ).
        lo_request->set_uri_path( '/workflow/rest/v1/workflow-instances' ).
*        lo_request->set_query( query = 'environmentId=realestate' ).
        lo_request->set_query( query = 'environmentId=sbpatestforallprocess' ).
        lo_request->set_text( lv_json ).

        DATA(lo_response) = lo_http_client->execute( if_web_http_client=>post ).
        DATA(lv_status) = lo_response->get_status( ).
        DATA(lv_response_body) = lo_response->get_text( ).

*        IF lv_status-code NE 200 AND lv_status-code NE 201.
*          DATA(lv_response_body) = lo_response->get_text( ).
*          " Log warning
*        ENDIF.

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

            MODIFY ENTITIES OF zrefx_i_complaints
              ENTITY Complaints
                EXECUTE SetStatusSubmitted FROM VALUE #( ( ComplaintId = gs_context-complaintid ) )
                CREATE BY \_WorkflowInfo
                FIELDS ( ApprovalStep ApprovalStepDesc WfInstanceId CurrentStatus CurrentOwner SubmissionFromDate )
                WITH VALUE #( ( ComplaintId = gs_context-complaintid
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

      CATCH cx_http_dest_provider_error INTO DATA(lx_dest) ##NO_HANDLER.
        " Log - do not abort

      CATCH cx_web_http_client_error INTO DATA(lx_http) ##NO_HANDLER.
        " Log - do not abort

    ENDTRY.

  ENDMETHOD.


  METHOD set_context_data.

*    gs_context-complaintid      = complaintid.
*    gs_context-categorycode     = categorycode.
*    gs_context-complaintnumber  = complaintid.
*    gs_context-createdat        = createdat.
*    gs_context-createdby        = createdby.
*    gs_context-description      = description.

    gs_context-categorycode         = categorycode.
    gs_context-complainant          = complainant.
    gs_context-complantype          = complaintype.
    gs_context-complaintid          = complaintid.
    gs_context-description          = description.
    gs_context-isgovernmentinvolved = isgovernmentinvolved.
    gs_context-landid               = landid.
    gs_context-maindvmorgunit       = maindvmorgunit.
    gs_context-requestorowner       = requestorowner.
    gs_context-requireslegal        = requireslegal.
    gs_context-sourcechannel        = sourcechannel.
    gs_context-status               = status.
    gs_context-submittedby          = submittedby.
    gs_context-submittedon          = submittedon.

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
