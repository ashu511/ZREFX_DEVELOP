CLASS zcl_refx_vendor_f4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_refx_vendor_f4 IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    " 1. Ensure the request is for data
    IF NOT io_request->is_data_requested( ).
      RETURN. " Exit early if the UI is not asking for data
    ENDIF.

    io_request->get_sort_elements( ).
    io_request->get_paging( ).

    TRY.
        " 2. Get the filter from the UI Binding and convert it to OData $filter format
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).

        " 3. Establish connection via BTP Destination 'refx_gw_ba'
        DATA(lo_dest) = cl_http_destination_provider=>create_by_cloud_destination(
          i_name      = 'refx_gw_ba' ).
*            i_name      = 'refx_gw_pp' ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

        " 4. Initialize the OData Client Proxy
        DATA(lo_client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
                                EXPORTING is_proxy_model_key        = VALUE #( repository_id       = 'DEFAULT'
                                                                               proxy_model_id      = 'ZREFX_ECC_VENDOR_DETAILS'
                                                                               proxy_model_version = '0001' )
                                          io_http_client            = lo_http_client
                                          iv_relative_service_root  = '/sap/opu/odata/sap/ZREFX_API_CMPCLM_SRV/'
                                         ).

        " 5. Create the Read Request for the specific Entity Set
        DATA(lo_read_request) = lo_client_proxy->create_resource_for_entity_set( 'VENDOR_DETAILS_SET' )->create_request_for_read( ).

        " 6. Map the RAP filter to the OData $filter
        DATA(lo_filter_factory) = lo_read_request->create_filter_factory( ).
        DATA lo_root_filter_node  TYPE REF TO /iwbep/if_cp_filter_node.
        DATA lv_odata_property TYPE string.

        LOOP AT lt_filter_cond INTO DATA(ls_filter).

          CLEAR lv_odata_property.

          " Map RAP Custom Entity field names
          " to the exact OData property names defined in your ECC API.
          CASE ls_filter-name.
            WHEN 'VENDORID'.
              lv_odata_property = 'VENDOR_ID'.   " <-- Update to match your ECC OData name!

              " Pad user input with leading zeros so ECC can find it
              LOOP AT ls_filter-range ASSIGNING FIELD-SYMBOL(<fs_range>).
                " Only pad if the user typed numbers
                IF <fs_range>-low CO ' 0123456789'.
                  " Force the string to be 10 chars, right-aligned, padded with '0'
                  <fs_range>-low = |{ condense( <fs_range>-low ) WIDTH = 10 ALIGN = RIGHT PAD = '0' }|.
                ENDIF.

                IF <fs_range>-high IS NOT INITIAL AND <fs_range>-high CO ' 0123456789'.
                  <fs_range>-high = |{ condense( <fs_range>-high ) WIDTH = 10 ALIGN = RIGHT PAD = '0' }|.
                ENDIF.
              ENDLOOP.

            WHEN 'VENDORNAME'.
              lv_odata_property = 'VENDOR_NAME'. " <-- Update to match your ECC OData name!
            WHEN OTHERS.
              CONTINUE. " Ignore any other fields
          ENDCASE.

          " Create a filter node for the current field's range
          DATA(lo_current_filter) = lo_filter_factory->create_by_range(
            iv_property_path = lv_odata_property
            it_range         = ls_filter-range ).

          " Chain the filters together with AND
          IF lo_root_filter_node IS INITIAL.
            lo_root_filter_node = lo_current_filter.
          ELSE.
            lo_root_filter_node = lo_root_filter_node->and( lo_current_filter ).
          ENDIF.
        ENDLOOP.

        " Attach the chained filter to the read request
        IF lo_root_filter_node IS BOUND.
          lo_read_request->set_filter( lo_root_filter_node ).
        ENDIF.

*        " 7. PERFORMANCE: Map UI Paging ($top / $skip) to OData Request
*        " Activate this only if ECC API supports $top and $skip for pagination.
*        IF io_request->get_paging( ) IS BOUND.
*          DATA(lv_top)  = io_request->get_paging( )->get_page_size( ).
*          DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
*
*          IF lv_top > 0 AND lv_top <> if_rap_query_paging=>page_size_unlimited.
*            lo_read_request->set_skip( CONV i( lv_skip ) ).
*            lo_read_request->set_top( CONV i( lv_top ) ).
*          ENDIF.
*        ENDIF.

        " 8. Execute the request
        TRY.
            DATA(lo_response) = lo_read_request->execute( ).
          CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
            " This will often contain the HTML or JSON error from ECC
            DATA(lv_error_text) = lx_gateway->get_text( ).
            " If you are in debug mode, inspect lx_gateway->http_status_code
        ENDTRY.

        " 9. Retrieve and Map the results
        " Use the internal structure type generated by your SCM for 'VENDOR_DETAILS_SET'
        DATA lt_external_data TYPE zrefx_ecc_vendor_details=>tyt_vendor_details. "SCM type
        DATA lt_result_data   TYPE TABLE OF zrefx_i_vendor_f4. "Custom Entity type
        DATA lt_paged_entity  TYPE TABLE OF zrefx_i_vendor_f4. "Custom Entity type

        lo_response->get_business_data( IMPORTING et_business_data = lt_external_data ).

        " Manual mapping of ECC structure to Custom Entity fields
        lt_result_data = CORRESPONDING #( lt_external_data MAPPING
                                        Vendorid             = vendor_id
                                        Vendorname           = vendor_name
                                        Vendorcompanyname    = vendor_company_name
                                        Contactpersonname    = contact_person_name
                                        Contactmobile        = vendor_mob_number
*                                Vendoraltnum         = vendor_alt_num
                                        Vendorregistrationno = vendor_reg_num
                                        Contactemail         = vendor_email_id
*                                Preferredlanguage    = preferred_language
                                        Vendoraddress        = vendor_address ).

        " Remove leading zeros for display purposes in the UI
        LOOP AT lt_result_data ASSIGNING FIELD-SYMBOL(<fs_clean_row>).
          <fs_clean_row>-Vendorid = shift_left( val = <fs_clean_row>-Vendorid sub = '0' ).
        ENDLOOP.

        " 10. Send the paginated data and total count back to the UI
        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( lt_result_data ) ).
        ENDIF.

        DATA(lv_top)  = io_request->get_paging( )->get_page_size( ).
        DATA(lv_skip) = io_request->get_paging( )->get_offset( ).

        IF lv_top > 0 AND lv_top <> if_rap_query_paging=>page_size_unlimited.
          " Calculate the slice boundaries
          DATA(lv_start) = lv_skip + 1.
          DATA(lv_end)   = lv_skip + lv_top.

          " Manually extract only the requested rows
          LOOP AT lt_result_data ASSIGNING FIELD-SYMBOL(<fs_row>)
               FROM lv_start TO lv_end.
            APPEND <fs_row> TO lt_paged_entity.
          ENDLOOP.

          " Return the safely sliced data to RAP
          io_response->set_data( lt_paged_entity ).

        ELSE.
          " Return all data if no specific top size was requested
          io_response->set_data( lt_result_data ).
        ENDIF.


      CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
        " Error if destination 'refx_gw_ba' is missing in BTP Cockpit
        RAISE SHORTDUMP lx_dest.
      CATCH cx_web_http_client_error INTO DATA(lx_http).
        " Error with network or Cloud Connector connection
        RAISE SHORTDUMP lx_http.
      CATCH /iwbep/cx_gateway INTO DATA(lx_proxy).
        " Error mapping OData results
        RAISE SHORTDUMP lx_proxy.
        "handle exception
      CATCH cx_rap_query_filter_no_range ##NO_HANDLER.
        "handle exception
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
