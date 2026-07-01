CLASS lhc_attachments DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Attachments RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR attachments RESULT result.
    METHODS download FOR MODIFY
      IMPORTING keys FOR ACTION attachments~download RESULT result.

ENDCLASS.

CLASS lhc_attachments IMPLEMENTATION.

  METHOD get_instance_features.

    "Read the DMS ID to check if the record was already processed by the system
    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Attachments
      FIELDS ( Dmsid ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_attachments).

    result = VALUE #( FOR attachment IN lt_attachments
                        ( %tky = attachment-%tky
                          %features-%update = COND #(
                          " CONDITION 1: It is a brand new record (No ID yet)
                          " We must allow update so the user can fill initial fields
                          WHEN attachment-Dmsid IS INITIAL
                          THEN if_abap_behv=>fc-o-enabled

                          " CONDITION 2: The DMS ID is present.
                          " This means the background process already ran. Lock it.
                          ELSE if_abap_behv=>fc-o-disabled )
                        )
                    ).

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD download.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).

      DATA : lv_documentid TYPE string,
             lv_repo_id    TYPE string.

      lv_documentid = <ls_key>-%param-documentid.

* Get the CMIS Client
      DATA(lo_cmis_client) = cl_cmis_client_factory2=>get_instance( ).

* Download the object                                                                                     *
      SELECT SINGLE config_value
        FROM zrefx_btp_config
        WHERE object_id   = 'repository_id'
        INTO @lv_repo_id.

      CALL METHOD lo_cmis_client->get_content_stream
        EXPORTING
          iv_repository_id = lv_repo_id
          iv_object_id     = lv_documentid
        IMPORTING
          es_content       = DATA(lv_content).

* Pass value back to the front-end as response
      APPEND VALUE #(
       %cid   = <ls_key>-%cid
       %param = VALUE #( content = lv_content-stream )
       ) TO result.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zrefx_i_complaints DEFINITION INHERITING FROM cl_abap_behavior_saver.


  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zrefx_i_complaints IMPLEMENTATION.

  METHOD cleanup_finalize.
  ENDMETHOD.

  METHOD adjust_numbers.
*    DATA: lv_number TYPE n LENGTH 10.
*    DATA:
*      lv_max        TYPE string,
*      lv_num_part   TYPE i,
*      lv_new_number TYPE string.
    DATA lv_number_raw TYPE cl_numberrange_runtime=>nr_number. "value from number range
*    DATA lv_reqno      TYPE string.
*    DATA: lv_number_raw1 TYPE char10.

*    SELECT MAX( complaint_id  ) FROM zrefx_complaints INTO @DATA(lv_max1).
*   lv_max1 = lv_max1+7(6).
*    DATA(lv_new_key) = lv_max1 + 1.
    LOOP AT mapped-complaints ASSIGNING FIELD-SYMBOL(<fs_order>).
*      <fs_order>-ComplaintId = lv_new_key.
*      lv_reqno = |{ CONV i( lv_number_raw ) }|.
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = '01'
              object            = 'ZREFX_CMNR'
*              quantity          = 1
            IMPORTING
              number            = lv_number_raw
          ).
        CATCH cx_number_ranges INTO DATA(lx_error) ##NO_HANDLER.

      ENDTRY.

      <fs_order>-ComplaintId = |{ CONV i( lv_number_raw ) }|.

      DATA(current_date) = cl_abap_context_info=>get_system_date( ).
      DATA(current_year) = current_date(4).
      <fs_order>-ComplaintId =  |{ 'CMP' } {  current_year } { <fs_order>-ComplaintId }|.
      CONDENSE <fs_order>-ComplaintId NO-GAPS.
    ENDLOOP.

* Attachments
    LOOP AT mapped-attachments ASSIGNING FIELD-SYMBOL(<lfs_att>).
      TRY.
          DATA(lv_attachid) = cl_system_uuid=>create_uuid_c32_static( ).
        CATCH cx_uuid_error.
          " Handle exception: Add message to reported or skip
          CONTINUE.
      ENDTRY.

      DATA(lv_ComplaintId) = <lfs_att>-%tmp-ComplaintId.

      <lfs_att>-ComplaintId  = lv_ComplaintId.
      <lfs_att>-AttachmentId = lv_attachid.

    ENDLOOP.

* Workflow Information
    " Generate UUIDs for new Workflow Log lines
    LOOP AT mapped-workflowinfo ASSIGNING FIELD-SYMBOL(<lfs_wf>).
      TRY.
          <lfs_wf>-LogUuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          CONTINUE.
      ENDTRY.
      <lfs_wf>-ComplaintId = <lfs_wf>-%tmp-ComplaintId.
    ENDLOOP.

  ENDMETHOD.

  METHOD save_modified.

    " Variables to Trigger the SBPA for created complaints
    DATA: lo_operation TYPE REF TO zcl_refx_bgpf_complaints_sbpa,
          lo_process   TYPE REF TO if_bgmc_process_single_op,
          lx_bgmc      TYPE REF TO cx_bgmc.

    " Variables for DMS Background Process
    DATA: lo_dms_op     TYPE REF TO zcl_refx_bgpf_comp_dms_up,
          lt_dms_create TYPE zcl_refx_bgpf_comp_dms_up=>tt_context,
          lo_dms_del    TYPE REF TO zcl_refx_bgpf_comp_dms_del,
          lt_dms_delete TYPE zcl_refx_bgpf_comp_dms_del=>tt_context.

    IF create-complaints IS NOT INITIAL.

      LOOP AT create-complaints INTO DATA(ls_complaint).

        TRY.
            " 1. Create an operation instance
            lo_operation = NEW zcl_refx_bgpf_complaints_sbpa( ).

            " 2. Set the context data - this will be passed to the SBPA workflow

            " Get the current user's technical name and formatted name for the 'CreatedBy' and 'SubmittedBy' fields in the workflow context
            DATA(lv_user_id) = cl_abap_context_info=>get_user_technical_name( ).
            TRY.
                DATA(lv_user_name) = cl_abap_context_info=>get_user_formatted_name( ).
              CATCH cx_abap_context_info_error ##NO_HANDLER.
                "handle exception
            ENDTRY.

*            lo_operation->set_context_data( complaintid     = ls_complaint-ComplaintId
*                                            categorycode    = ls_complaint-Complaintcategory
*                                            complaintnumber = ls_complaint-ComplaintId
*                                            createdat       = ls_complaint-Createddate
*                                            createdby       = lv_user_id
*                                            description     = ls_complaint-Detaileddescription  ).
            lo_operation->set_context_data(
                            complaintid          = ls_complaint-ComplaintId
                            categorycode         = ls_complaint-Complaintcategory
                            description          = ls_complaint-Detaileddescription
                            landid               = ls_complaint-Landid
                            titledeed            = ls_complaint-Titledeedno
                            sourcechannel        = ls_complaint-Sourcechannel
                            status               = ls_complaint-Status
                            submittedon          = ls_complaint-Createddate
                            complainant          = ls_complaint-Vendorname
                            requestorowner       = ''  " Map to actual field if available
                            maindvmorgunit       = ls_complaint-MainDivision
                            isgovernmentinvolved = abap_false
                            requireslegal        = abap_false
                            vendoremail          = ls_complaint-Contactemail
                            vendorname_en        = ls_complaint-Vendorname
                            vendorname_ar        = ls_complaint-Vendorname
                            submittedby          = lv_user_name
                            complaintype         = ls_complaint-Complainttype
                        ).

            " 3. Get the bgPF process factory and create a process
            lo_process = cl_bgmc_process_factory=>get_default( )->create( ).

            " 4. Set a name for monitoring and inject the operation
            lo_process->set_name( 'CallComplaintsBPA' )->set_operation( lo_operation ).

            " 5. Save for execution (the actual trigger happens after COMMIT)
            lo_process->save_for_execution( ).

          CATCH cx_bgmc INTO lx_bgmc ##NO_HANDLER.
            " Handle registration errors here
        ENDTRY.

      ENDLOOP.

    ENDIF.

    IF create-attachments IS NOT INITIAL.

      LOOP AT create-attachments ASSIGNING FIELD-SYMBOL(<lfs_attachment>).

        "Skip if there's no content to upload
        IF <lfs_attachment>-content IS INITIAL.
          CONTINUE.
        ENDIF.

        APPEND VALUE #(
          complaintid  = <lfs_attachment>-ComplaintId
          attachmentid = <lfs_attachment>-attachmentid
          content      = <lfs_attachment>-content
          filename     = <lfs_attachment>-filename
          mimetype     = <lfs_attachment>-mimetype
        ) TO lt_dms_create.

      ENDLOOP.

      "Only schedule BgPF if we actually have files to process
      IF lt_dms_create IS NOT INITIAL.

        TRY.

            lo_dms_op = NEW zcl_refx_bgpf_comp_dms_up( ).

            lo_dms_op->set_context_data( it_context = lt_dms_create ).

            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentUpload' )->set_operation( lo_dms_op )->save_for_execution( ).

          CATCH cx_bgmc INTO lx_bgmc ##NO_HANDLER.

            " Handle queue registration failure

        ENDTRY.

      ENDIF.

    ENDIF.

    IF delete-attachments IS NOT INITIAL.

      LOOP AT delete-attachments ASSIGNING FIELD-SYMBOL(<lfs_delete>).

        "Skip if there's no attachment or complaint id - both are required to identify the file to delete
        IF <lfs_delete>-AttachmentId IS INITIAL AND <lfs_delete>-ComplaintId IS INITIAL.
          CONTINUE.
        ENDIF.

        APPEND VALUE #(
          complaintid  = <lfs_delete>-ComplaintId
          attachmentid = <lfs_delete>-attachmentid
        ) TO lt_dms_delete.

      ENDLOOP.

      "Only schedule BgPF if we actually have files to process
      IF lt_dms_delete IS NOT INITIAL.

        " Fetch the dmsid from your Z-table before passing it to the background process
        SELECT complaint_id, attachment_id, dmsid
          FROM zrefx_att_comp
          FOR ALL ENTRIES IN @lt_dms_delete
          WHERE complaint_id = @lt_dms_delete-complaintid
            AND attachment_id = @lt_dms_delete-attachmentid
          INTO TABLE @DATA(lt_dms_info).

        " Update your context to include the dmsid
        LOOP AT lt_dms_delete ASSIGNING FIELD-SYMBOL(<ls_del>).
          READ TABLE lt_dms_info INTO DATA(ls_info)
            WITH KEY complaint_id = <ls_del>-complaintid
                     attachment_id = <ls_del>-attachmentid.
          IF sy-subrc = 0.
            <ls_del>-documentid = ls_info-dmsid.
          ENDIF.
        ENDLOOP.

        TRY.

            lo_dms_del = NEW zcl_refx_bgpf_comp_dms_del( ).

            lo_dms_del->set_context_data( it_context = lt_dms_delete ).

            cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'DMSAttachmentDelete' )->set_operation( lo_dms_del )->save_for_execution( ).

          CATCH cx_bgmc INTO lx_bgmc ##NO_HANDLER.

            " Handle queue registration failure

        ENDTRY.

      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZREFX_I_COMPLAINTS DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

  PRIVATE SECTION.

*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR Complaints RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Complaints RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR complaints RESULT result.
*    METHODS validateemail FOR VALIDATE ON SAVE
*      IMPORTING keys FOR complaints~validateemail.
    METHODS setinitialdate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR complaints~setinitialdate.
    METHODS setstatusdraft FOR DETERMINE ON MODIFY
      IMPORTING keys FOR complaints~setstatusdraft.
*    METHODS updatedivisions FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR complaints~updatedivisions.
    METHODS populateexternalvendor FOR DETERMINE ON MODIFY
      IMPORTING keys FOR complaints~populateexternalvendor.
    METHODS fetchvendordetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR complaints~fetchvendordetails.
    METHODS validate_confirminformation FOR VALIDATE ON SAVE
      IMPORTING keys FOR complaints~validate_confirminformation.
    METHODS updatedivision FOR MODIFY
      IMPORTING keys FOR ACTION complaints~updatedivision RESULT result.
    METHODS Updateworkflowinfo FOR MODIFY
      IMPORTING keys FOR ACTION complaints~updateworkflowinfo RESULT result.
    METHODS SetStatusSubmitted FOR MODIFY
      IMPORTING keys FOR ACTION Complaints~SetStatusSubmitted RESULT result.
    METHODS validateMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR Complaints~validateMandatoryFields.

ENDCLASS.

CLASS lhc_ZREFX_I_COMPLAINTS IMPLEMENTATION.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.

    " 1. Retrieve the current user's email ID from system context
    TRY.
        " Get the technical user name (Replacement for SY-UNAME)
        DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).

        SELECT SINGLE \_WorkplaceAddress-DefaultEmailAddress
            FROM I_BusinessUserBasic WITH PRIVILEGED ACCESS
            WHERE UserID = @lv_technical_name
            INTO @DATA(lv_email).

      CATCH cx_abap_context_info_error INTO DATA(lx_error) ##NO_HANDLER.
        " Fallback if the system environment fails to retrieve context info
    ENDTRY.

    " 2. Determine external vendor flag based on the retrieved email address
    " If the logged-in user's email does not contain '@se.com.sa', External Vendor.
    IF lv_email NS '@se.com.sa'.
      DATA(lv_external_vendor) = abap_true.
    ELSE.
      lv_external_vendor  = abap_false.
    ENDIF.

    " 3. Read the incoming instances to match their transaction keys (%tky)
    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Complaints
        FIELDS ( ComplaintId Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_complaints)
      FAILED failed.

    " 4. Apply the field control state across all processing instances
    LOOP AT lt_complaints ASSIGNING FIELD-SYMBOL(<fs_complaint>).

      " --- UI LOCK LOGIC ---
      " If the status is running, disable Edit and Delete buttons entirely
      " This is to be considered for both internal and external users to prevent any tampering while the workflow is running
      DATA(lv_is_locked) = COND #( WHEN <fs_complaint>-Status = 'Submitted'
                                     OR <fs_complaint>-Status = 'Rejected'
                                     OR <fs_complaint>-Status = 'Completed'
                                   THEN if_abap_behv=>fc-o-disabled
                                   ELSE if_abap_behv=>fc-o-enabled ).

      IF lv_external_vendor = abap_true.
        " --- EXTERNAL USER ---
        " Everything is completely locked; populated purely via background OData API
        APPEND VALUE #( %tky                       = <fs_complaint>-%tky
                       %update                     = lv_is_locked
                       %delete                     = lv_is_locked
                       %action-Edit                = lv_is_locked
                       %field-Vendorid             = if_abap_behv=>fc-f-read_only
                       %field-Vendorname           = if_abap_behv=>fc-f-read_only
                       %field-Vendorcompanyname    = if_abap_behv=>fc-f-read_only
                       %field-Contactpersonname    = if_abap_behv=>fc-f-read_only
                       %field-Contactmobile        = if_abap_behv=>fc-f-read_only
                       %field-Vendoraltnum         = if_abap_behv=>fc-f-read_only
                       %field-Vendorregistrationno = if_abap_behv=>fc-f-read_only
                       %field-Contactemail         = if_abap_behv=>fc-f-read_only
*                       %field-Preferredlanguage    = if_abap_behv=>fc-f-read_only
                       %field-Vendoraddress        = if_abap_behv=>fc-f-read_only ) TO result.
      ELSE.
        " --- INTERNAL USER ---
        " Can type or use F4 on Vendor ID, but cannot manually tamper with details fields
        APPEND VALUE #( %tky                       = <fs_complaint>-%tky
                       %update                     = lv_is_locked
                       %delete                     = lv_is_locked
                       %action-Edit                = lv_is_locked
                       %field-Vendorid             = if_abap_behv=>fc-f-mandatory
                       %field-Vendorname           = if_abap_behv=>fc-f-read_only
                       %field-Vendorcompanyname    = if_abap_behv=>fc-f-read_only
                       %field-Contactpersonname    = if_abap_behv=>fc-f-read_only
                       %field-Contactmobile        = if_abap_behv=>fc-f-read_only
                       %field-Vendoraltnum         = if_abap_behv=>fc-f-read_only
                       %field-Vendorregistrationno = if_abap_behv=>fc-f-read_only
                       %field-Contactemail         = if_abap_behv=>fc-f-read_only
*                       %field-Preferredlanguage    = if_abap_behv=>fc-f-read_only
                       %field-Vendoraddress        = if_abap_behv=>fc-f-read_only ) TO result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

*  METHOD validateEmail.
*
*    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
*       ENTITY Complaints
*       FIELDS ( Contactemail )
*       WITH CORRESPONDING #( keys )
*       RESULT DATA(lt_email).
*
*    LOOP AT lt_email ASSIGNING FIELD-SYMBOL(<fs_data>).
*      DATA(lv_email) = to_lower( condense( <fs_data>-Contactemail  ) ).
*      FIND REGEX '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
*           IN lv_email
*      MATCH COUNT DATA(lv_match).
*      IF lv_match = 0.
*        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-complaints.
*
*        APPEND VALUE #(
*          %tky = <fs_data>-%tky
*          %msg = new_message_with_text(
*           text = 'Not a valid email id'
*            severity = if_abap_behv_message=>severity-error
*          )
*          %element-Contactemail  = if_abap_behv=>mk-on
*        ) TO reported-complaints.
*      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD setInitialDate.
    " Read the keys of the instances being created
    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Complaints
      FIELDS ( Createddate ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_complaints).

    " Filter out records that already have a date
    DELETE lt_complaints WHERE Createddate IS NOT INITIAL.
    CHECK lt_complaints IS NOT INITIAL.

    " Update the entities with the current system date
    MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Complaints
*      UPDATE FIELDS ( Createddate Consentdate  )
      UPDATE FIELDS ( Createddate )
      WITH VALUE #( FOR travel IN lt_complaints (
          %tky      = travel-%tky
          Createddate = cl_abap_context_info=>get_system_date( )
*          Consentdate = cl_abap_context_info=>get_system_date( )
      ) ).

  ENDMETHOD.

  METHOD setStatusDraft.
    " Read the keys of the instances being created
    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Complaints
      FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_comp_Status).

    " Filter out records that already have a date
    DELETE lt_comp_Status WHERE Status IS NOT INITIAL.
    CHECK lt_comp_Status IS NOT INITIAL.

    " Update the entities with the current system date
    MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Complaints
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR status IN lt_comp_Status (
          %tky      = status-%tky
          Status =  'Draft'
      ) ).

  ENDMETHOD.

*  METHOD updateDivisions.
*
*    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
*     ENTITY Complaints
*     FIELDS ( City ) WITH CORRESPONDING #( keys )
*     RESULT DATA(lt_Comp_Divisions).
*
*    LOOP AT lt_Comp_Divisions ASSIGNING FIELD-SYMBOL(<fs_data>).
*      IF <fs_data>-City = '10'.
*        MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
*        ENTITY Complaints
*        UPDATE
*        FIELDS ( MainDivision SubDivision ) WITH VALUE #( ( %tky =  <fs_data>-%tky  MainDivision = '10'  SubDivision = '10' ) ).
*      ENDIF.
*      IF <fs_data>-City = '20'.
*        MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
*        ENTITY Complaints
*        UPDATE
*        FIELDS ( MainDivision SubDivision ) WITH VALUE #( ( %tky =  <fs_data>-%tky  MainDivision = '20'  SubDivision = '20' ) ).
*      ENDIF.
*      IF <fs_data>-City = '30'.
*        MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
*        ENTITY Complaints
*        UPDATE
*        FIELDS ( MainDivision SubDivision ) WITH VALUE #( ( %tky =  <fs_data>-%tky  MainDivision = '30'  SubDivision = '30' ) ).
*      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD populateExternalVendor.

    TYPES: BEGIN OF ty_range_line,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE string,
             high   TYPE string,
           END OF ty_range_line,
           tt_range_tab TYPE STANDARD TABLE OF ty_range_line WITH EMPTY KEY.

    DATA lt_vendor_range TYPE tt_range_tab.

    DATA: lv_email  TYPE string,
          lt_update TYPE TABLE FOR UPDATE zrefx_i_complaints.

    " 1. Verify if user is actually external
    TRY.
        DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).
        SELECT SINGLE \_WorkplaceAddress-DefaultEmailAddress
            FROM I_BusinessUserBasic WITH PRIVILEGED ACCESS
            WHERE UserID = @lv_technical_name
            INTO @lv_email.
      CATCH cx_abap_context_info_error.
        RETURN.
    ENDTRY.

    IF lv_email CS '@se.com.sa'.
      RETURN. " Exit if internal user
    ENDIF.

    " 2. Call your ECC OData Service API
    TRY.

        " Establish connection via BTP Destination 'refx_gw_ba'
        DATA(lo_dest) = cl_http_destination_provider=>create_by_cloud_destination(
          i_name      = 'refx_gw_ba' ).
*          i_name      = 'refx_gw_pp' ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

        " Initialize the OData Client Proxy
        DATA(lo_client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
                                EXPORTING is_proxy_model_key        = VALUE #( repository_id       = 'DEFAULT'
                                                                               proxy_model_id      = 'ZREFX_ECC_VENDOR_DETAILS'
                                                                               proxy_model_version = '0001' )
                                          io_http_client            = lo_http_client
                                          iv_relative_service_root  = '/sap/opu/odata/sap/ZREFX_API_CMPCLM_SRV/'
                                         ).

        " Create the Read Request for the specific Entity Set
        DATA(lo_read_request) = lo_client_proxy->create_resource_for_entity_set( 'VENDOR_DETAILS_SET' )->create_request_for_read( ).

        " Map the RAP filter to the OData $filter=VendorEmailId eq 'user_email'
        DATA(lo_filter_factory) = lo_read_request->create_filter_factory( ).

        " Create a range table manually for the 'Field' property
        lt_vendor_range = VALUE #( (  sign   = 'I'
                                      option = 'EQ'
                                      low    =  lv_email ) ).

        " Apply this range to the 'Field' property in the OData request
        DATA(lo_filter) = lo_filter_factory->create_by_range(
                             iv_property_path = 'VENDOR_EMAIL_ID'
                             it_range         = lt_vendor_range ).

        lo_read_request->set_filter( lo_filter ).

        " Execute the request
        TRY.
            DATA(lo_response) = lo_read_request->execute( ).
          CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
            " This will often contain the HTML or JSON error from ECC
            DATA(lv_error_text) = lx_gateway->get_text( ).
            " If you are in debug mode, inspect lx_gateway->http_status_code
        ENDTRY.

        " Retrieve and Map the results
        " Use the internal structure type generated by your SCM for 'VendorDetailSet'
        DATA lt_external_data TYPE zrefx_ecc_vendor_details=>tyt_vendor_details. "SCM type

        lo_response->get_business_data( IMPORTING et_business_data = lt_external_data ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
        " Error if destination 'refx_gw_ba' is missing in BTP Cockpit
        RAISE SHORTDUMP lx_dest.
      CATCH cx_web_http_client_error INTO DATA(lx_http).
        " Error with network or Cloud Connector connection
        RAISE SHORTDUMP lx_http.
      CATCH /iwbep/cx_gateway INTO DATA(lx_proxy).
        " Error mapping OData results
        RAISE SHORTDUMP lx_proxy..
        "handle exception
    ENDTRY.

    " 3. Read current keys
    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Complaints
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_complaints).

    " 4. Update the draft state with ECC data
    IF lt_external_data IS NOT INITIAL.

      " Read the first matching vendor record returned from ECC
      DATA(ls_ecc_data) = lt_external_data[ 1 ].

      " Remove leading zeros from Vendor ID
      ls_ecc_data-Vendor_id = shift_left( val = ls_ecc_data-vendor_id sub = '0' ).

      LOOP AT lt_complaints ASSIGNING FIELD-SYMBOL(<fs_complaint>).
        APPEND VALUE #( %tky = <fs_complaint>-%tky ) TO lt_update ASSIGNING FIELD-SYMBOL(<fs_modify>).
        <fs_modify>-Vendorid             = ls_ecc_data-vendor_id.
        <fs_modify>-Vendorname           = ls_ecc_data-vendor_name.
        <fs_modify>-Vendorcompanyname    = ls_ecc_data-vendor_company_name.
        <fs_modify>-Contactpersonname    = ls_ecc_data-contact_person_name.
        <fs_modify>-Contactmobile        = ls_ecc_data-vendor_mob_number.
*      <fs_modify>-Vendoraltnum         = ls_ecc_data-.
        <fs_modify>-Vendorregistrationno = ls_ecc_data-vendor_reg_num.
        <fs_modify>-Contactemail         = ls_ecc_data-vendor_email_id.
*      <fs_modify>-Preferredlanguage    = ls_ecc_data-.
        <fs_modify>-Vendoraddress        = ls_ecc_data-vendor_address.
      ENDLOOP.

      IF lt_update IS NOT INITIAL.
        MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
          ENTITY Complaints UPDATE FIELDS ( Vendorid Vendorname Vendorcompanyname Contactpersonname
                                            Contactmobile Vendoraltnum Vendorregistrationno
                                            Contactemail  Vendoraddress ) WITH lt_update.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD fetchVendorDetails.

    TYPES: BEGIN OF ty_range_line,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE string,
             high   TYPE string,
           END OF ty_range_line,
           tt_range_tab TYPE STANDARD TABLE OF ty_range_line WITH EMPTY KEY.

    " 1. Read the newly selected Vendorid from the draft
    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Complaints
        FIELDS ( Vendorid ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_complaints).

    DATA lt_update TYPE TABLE FOR UPDATE zrefx_i_complaints.
    DATA lt_external_data TYPE zrefx_ecc_vendor_details=>tyt_vendor_details.

    LOOP AT lt_complaints ASSIGNING FIELD-SYMBOL(<fs_complaint>) WHERE Vendorid IS NOT INITIAL.

      DATA(lv_padded_vendor) = |{ <fs_complaint>-Vendorid ALPHA = IN }|.

      " 2. Fetch the specific Vendor from ECC OData via SCM
      TRY.
          DATA(lo_dest) = cl_http_destination_provider=>create_by_cloud_destination( 'refx_gw_ba' ).
*          DATA(lo_dest) = cl_http_destination_provider=>create_by_cloud_destination( 'refx_gw_pp' ).
          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

          DATA(lo_client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
                                    EXPORTING is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                                                  proxy_model_id      = 'ZREFX_ECC_VENDOR_DETAILS'
                                                                                  proxy_model_version = '0001' )
                                              io_http_client           = lo_http_client
                                              iv_relative_service_root = '/sap/opu/odata/sap/ZREFX_API_CMPCLM_SRV/' ).

          DATA(lo_read_request) = lo_client_proxy->create_resource_for_entity_set( 'VENDOR_DETAILS_SET' )->create_request_for_read( ).

          " Filter by the selected Vendor ID
          DATA(lo_filter) = lo_read_request->create_filter_factory( )->create_by_range(
                               iv_property_path = 'VENDOR_ID' " Replace with your exact SCM property name for Vendor ID
                               it_range         = VALUE tt_range_tab( ( sign = 'I' option = 'EQ' low = lv_padded_vendor ) ) ).

          lo_read_request->set_filter( lo_filter ).
          DATA(lo_response) = lo_read_request->execute( ).
          lo_response->get_business_data( IMPORTING et_business_data = lt_external_data ).

          IF lt_external_data IS NOT INITIAL.
            DATA(ls_ecc_data) = lt_external_data[ 1 ].

            " 3. Map values to update the draft
            APPEND VALUE #( %tky = <fs_complaint>-%tky
                            Vendorname           = ls_ecc_data-vendor_name
                            Vendorcompanyname    = ls_ecc_data-vendor_company_name
                            Contactpersonname    = ls_ecc_data-contact_person_name
                            Contactmobile        = ls_ecc_data-vendor_mob_number
                            Vendorregistrationno = ls_ecc_data-vendor_reg_num
                            Contactemail         = ls_ecc_data-vendor_email_id
                            Vendoraddress        = ls_ecc_data-vendor_address
                          ) TO lt_update.
          ENDIF.

        CATCH cx_root INTO DATA(lx_error) ##NO_HANDLER.
          " Handle errors if necessary
      ENDTRY.
    ENDLOOP.

    " 4. Update the read-only fields IN LOCAL MODE
    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
        ENTITY Complaints UPDATE FIELDS ( Vendorname Vendorcompanyname Contactpersonname
                                          Contactmobile Vendorregistrationno
                                          Contactemail Vendoraddress ) WITH lt_update.
    ENDIF.

  ENDMETHOD.

  METHOD validate_Confirminformation.

    " Read the necessary fields from the draft/active instance
    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Complaints
        FIELDS ( Confirminformation Consentdate ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_complaints).

    LOOP AT lt_complaints ASSIGNING FIELD-SYMBOL(<fs_complaint>).

      " Clear any previous error messages for this specific validation
      APPEND VALUE #( %tky        = <fs_complaint>-%tky
                      %state_area = 'VALIDATE_CONSENT' ) TO reported-complaints.

      " Check the condition: Checkbox is initial and Date is blank
      IF <fs_complaint>-Confirminformation  IS INITIAL AND <fs_complaint>-Consentdate IS INITIAL.

        " Mark the instance as failed so the save process is aborted
        APPEND VALUE #( %tky = <fs_complaint>-%tky ) TO failed-complaints.

        " Send the error message to the UI
        APPEND VALUE #( %tky = <fs_complaint>-%tky
                        %state_area = 'VALIDATE_CONSENT'
                        %msg = new_message_with_text(
                                 text = 'Kindly Maintain Confirmation'
                                 severity = if_abap_behv_message=>severity-error
                               )
                        " This highlights the 'Consentdate' field in red on the Fiori screen
                        %element-Consentdate         = if_abap_behv=>mk-on
                        %element-Confirminformation  = if_abap_behv=>mk-on
                      ) TO reported-complaints.
      ENDIF.

      " Check the condition: Checkbox is ticked ('X') but Date is blank
      IF <fs_complaint>-Confirminformation = abap_true AND <fs_complaint>-Consentdate IS INITIAL.

        " Mark the instance as failed so the save process is aborted
        APPEND VALUE #( %tky = <fs_complaint>-%tky ) TO failed-complaints.

        " Send the error message to the UI
        APPEND VALUE #( %tky = <fs_complaint>-%tky
                        %state_area = 'VALIDATE_CONSENT'
                        %msg = new_message_with_text(
                                 text = 'Kindly Maintain Confirmation Date!'
                                 severity = if_abap_behv_message=>severity-error
                               )
                        " This highlights the 'Consentdate' field in red on the Fiori screen
                        %element-Consentdate = if_abap_behv=>mk-on
                      ) TO reported-complaints.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD UpdateDivision.

    " 1. Read the parameters passed from SBPA
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
    IF sy-subrc = 0.

      " 2. Update the record using LOCAL MODE (bypasses UI read-only locks)
      MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
        ENTITY Complaints
          UPDATE FIELDS ( MainDivision Legalflag )
          WITH VALUE #( ( %tky         = <fs_key>-%tky
                          MainDivision = <fs_key>-%param-MainDivision
                          Legalflag    = <fs_key>-%param-Legalflag ) ).

      " 3. Return the updated record back to the caller
      READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
        ENTITY Complaints ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_complaints).

      result = VALUE #( FOR comp IN lt_complaints ( %tky = comp-%tky %param = comp ) ).

    ENDIF.

  ENDMETHOD.

  METHOD UpdateWorkflowInfo.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
    IF sy-subrc = 0.

      " Append a NEW line item for this approval step from SBPA
      MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
        ENTITY Complaints
          CREATE BY \_WorkflowInfo
          FIELDS ( WfInstanceId ApprovalStep ApprovalStepDesc ApproverEmail CurrentStatus CurrentOwner
                   CurrentOwnerDesig OrganizationField Comments DecisionOutcome SubmissionFromDate )
          WITH VALUE #( ( %tky = <fs_key>-%tky
                          %target = VALUE #( ( %cid               = 'SBPA_STEP'
                                               WfInstanceId       = <fs_key>-%param-WfInstanceId
                                               ApprovalStep       = <fs_key>-%param-ApprovalStep
                                               ApprovalStepDesc   = <fs_key>-%param-ApprovalStepDesc
                                               ApproverEmail      = <fs_key>-%param-ApproverEmail
                                               CurrentStatus      = <fs_key>-%param-CurrentStatus
                                               CurrentOwner       = <fs_key>-%param-CurrentOwner
                                               CurrentOwnerDesig  = <fs_key>-%param-CurrentOwnerDesig
                                               OrganizationField  = <fs_key>-%param-OrganizationField
                                               Comments           = <fs_key>-%param-Comments
*                                               AuthorityLevel     = <fs_key>-%param-AuthorityLevel
                                               DecisionOutcome    = <fs_key>-%param-DecisionOutcome
*                                               LegalInvolvement   = <fs_key>-%param-LegalInvolvement
                                               SubmissionFromDate = cl_abap_context_info=>get_system_date( ) ) ) ) ).

      " Evaluate the SBPA Status and determine if the Parent Complaint needs to close
      DATA lv_new_parent_status TYPE string.

      " Checking for both 'REJECT' and 'REJECTED' just to be safe with SBPA payloads
      IF <fs_key>-%param-CurrentStatus = 'REJECTED' OR <fs_key>-%param-CurrentStatus = 'REJECT'.
        lv_new_parent_status = 'Rejected'.
      ELSEIF <fs_key>-%param-CurrentStatus = 'COMPLETED'.
        lv_new_parent_status = 'Completed'.
      ENDIF.

      " If the workflow hit a final state, update the Parent Complaint Status
      IF lv_new_parent_status IS NOT INITIAL.
        MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
          ENTITY Complaints
            UPDATE FIELDS ( Status )
            WITH VALUE #( ( %tky = <fs_key>-%tky
                            Status = lv_new_parent_status ) ).
      ENDIF.

      " Return the parent entity to satisfy the OData Action response
      READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
        ENTITY Complaints ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_complaints).

      result = VALUE #( FOR comp IN lt_complaints ( %tky = comp-%tky %param = comp ) ).

    ENDIF.

  ENDMETHOD.

  METHOD SetStatusSubmitted.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
    IF sy-subrc = 0.

      MODIFY ENTITIES OF zrefx_i_complaints IN LOCAL MODE
        ENTITY Complaints
          UPDATE FIELDS ( Status )
          WITH VALUE #( ( %tky = <fs_key>-%tky Status = 'Submitted' ) ).

      " Return the updated record
      READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
        ENTITY Complaints ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_complaints).

      result = VALUE #( FOR comp IN lt_complaints ( %tky = comp-%tky %param = comp ) ).

    ENDIF.

  ENDMETHOD.

  METHOD validateMandatoryFields.

    " 1. Read the fields we need to validate from the draft
    READ ENTITIES OF zrefx_i_complaints IN LOCAL MODE
      ENTITY Complaints
        FIELDS ( Complaintcategory Vendorid ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_complaints).

    LOOP AT lt_complaints ASSIGNING FIELD-SYMBOL(<fs_complaint>).

      " 2. Clear any previous error messages for this specific validation
      APPEND VALUE #( %tky        = <fs_complaint>-%tky
                      %state_area = 'VALIDATE_MANDATORY' ) TO reported-complaints.

      " 3. Check Complaint Category
      IF <fs_complaint>-Complaintcategory IS INITIAL.
        APPEND VALUE #( %tky = <fs_complaint>-%tky ) TO failed-complaints.

        APPEND VALUE #( %tky = <fs_complaint>-%tky
                        %state_area = 'VALIDATE_MANDATORY'
                        %msg = new_message_with_text(
                                 text     = 'Complaint Category is mandatory.'
                                 severity = if_abap_behv_message=>severity-error )
                        " Highlights the specific field in red on the UI
                        %element-Complaintcategory = if_abap_behv=>mk-on
                      ) TO reported-complaints.
      ENDIF.

      " 4. Check Vendor ID
      IF <fs_complaint>-Vendorid IS INITIAL.
        APPEND VALUE #( %tky = <fs_complaint>-%tky ) TO failed-complaints.

        APPEND VALUE #( %tky = <fs_complaint>-%tky
                        %state_area = 'VALIDATE_MANDATORY'
                        %msg = new_message_with_text(
                                 text     = 'Vendor ID is mandatory.'
                                 severity = if_abap_behv_message=>severity-error )
                        " Highlights the specific field in red on the UI
                        %element-Vendorid = if_abap_behv=>mk-on
                      ) TO reported-complaints.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
