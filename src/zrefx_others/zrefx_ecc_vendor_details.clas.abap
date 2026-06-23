"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>ZREFX_API_CMPCLM_SRV</em>
CLASS zrefx_ecc_vendor_details DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">Approval</p>
      BEGIN OF tys_approval,
        "! EmpEmail
        emp_email      TYPE c LENGTH 30,
        "! LegalRequired
        legal_required TYPE abap_bool,
        "! Indicator
        indicator      TYPE c LENGTH 8,
        "! <em>Key property</em> Reqtype
        reqtype        TYPE c LENGTH 3,
        "! EmpPosition
        emp_position   TYPE c LENGTH 80,
        "! Pernr
        pernr          TYPE c LENGTH 8,
        "! EmpOrgid
        emp_orgid      TYPE c LENGTH 80,
        "! EmpOrgname
        emp_orgname    TYPE c LENGTH 80,
        "! Grade
        grade          TYPE c LENGTH 2,
        "! Begda
        begda          TYPE timestampl,
        "! Endda
        endda          TYPE timestampl,
        "! Agent
        agent          TYPE c LENGTH 8,
        "! Level
        level          TYPE c LENGTH 2,
        "! Name1
        name_1         TYPE c LENGTH 80,
        "! Pname
        pname          TYPE c LENGTH 80,
        "! <em>Key property</em> Orgname
        orgname        TYPE c LENGTH 80,
        "! Email
        email          TYPE c LENGTH 30,
        "! Uname
        uname          TYPE c LENGTH 12,
        "! Category
        category       TYPE c LENGTH 2,
      END OF tys_approval,
      "! <p class="shorttext synchronized">List of Approval</p>
      tyt_approval TYPE STANDARD TABLE OF tys_approval WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">F4SearchHelp</p>
      BEGIN OF tys_f_4_search_help,
        "! <em>Key property</em> Field
        field   TYPE c LENGTH 15,
        "! Value1
        value_1 TYPE c LENGTH 15,
        "! Descr1
        descr_1 TYPE c LENGTH 255,
      END OF tys_f_4_search_help,
      "! <p class="shorttext synchronized">List of F4SearchHelp</p>
      tyt_f_4_search_help TYPE STANDARD TABLE OF tys_f_4_search_help WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">VendorDetails</p>
      BEGIN OF tys_vendor_details,
        "! <em>Key property</em> VendorId
        vendor_id           TYPE string,
        "! VendorName
        vendor_name         TYPE string,
        "! VendorCompanyName
        vendor_company_name TYPE string,
        "! VendorMobNumber
        vendor_mob_number   TYPE string,
        "! <em>Key property</em> VendorEmailId
        vendor_email_id     TYPE c LENGTH 40,
        "! VendorAddress
        vendor_address      TYPE string,
        "! ContactPersonName
        contact_person_name TYPE string,
        "! VendorRegNum
        vendor_reg_num      TYPE string,
      END OF tys_vendor_details,
      "! <p class="shorttext synchronized">List of VendorDetails</p>
      tyt_vendor_details TYPE STANDARD TABLE OF tys_vendor_details WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">ZREFX_CENTRAL_RE_COORDINATOR</p>
      BEGIN OF tys_zrefx_central_re_coordin_2,
        "! <em>Key property</em> Orgeh
        orgeh  TYPE c LENGTH 8,
        "! Pernrs
        pernrs TYPE c LENGTH 300,
        "! Emails
        emails TYPE c LENGTH 339,
      END OF tys_zrefx_central_re_coordin_2,
      "! <p class="shorttext synchronized">List of ZREFX_CENTRAL_RE_COORDINATOR</p>
      tyt_zrefx_central_re_coordin_2 TYPE STANDARD TABLE OF tys_zrefx_central_re_coordin_2 WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! ApprovalSet
        "! <br/> Collection of type 'Approval'
        approval_set               TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'APPROVAL_SET',
        "! F4SearchHelpSet
        "! <br/> Collection of type 'F4SearchHelp'
        f_4_search_help_set        TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'F_4_SEARCH_HELP_SET',
        "! VendorDetailsSet
        "! <br/> Collection of type 'VendorDetails'
        vendor_details_set         TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'VENDOR_DETAILS_SET',
        "! ZREFX_CENTRAL_RE_COORDINATORSet
        "! <br/> Collection of type 'ZREFX_CENTRAL_RE_COORDINATOR'
        zrefx_central_re_coordinat TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZREFX_CENTRAL_RE_COORDINAT',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for Approval</p>
        "! See also structure type {@link ..tys_approval}
        BEGIN OF approval,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF approval,
        "! <p class="shorttext synchronized">Internal names for F4SearchHelp</p>
        "! See also structure type {@link ..tys_f_4_search_help}
        BEGIN OF f_4_search_help,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF f_4_search_help,
        "! <p class="shorttext synchronized">Internal names for VendorDetails</p>
        "! See also structure type {@link ..tys_vendor_details}
        BEGIN OF vendor_details,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF vendor_details,
        "! <p class="shorttext synchronized">Internal names for ZREFX_CENTRAL_RE_COORDINATOR</p>
        "! See also structure type {@link ..tys_zrefx_central_re_coordin_2}
        BEGIN OF zrefx_central_re_coordin_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF zrefx_central_re_coordin_2,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define Approval</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_approval RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define F4SearchHelp</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_f_4_search_help RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define VendorDetails</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_vendor_details RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define ZREFX_CENTRAL_RE_COORDINATOR</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_zrefx_central_re_coordin_2 RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS ZREFX_ECC_VENDOR_DETAILS IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'ZREFX_API_CMPCLM_SRV' ) ##NO_TEXT.

    def_approval( ).
    def_f_4_search_help( ).
    def_vendor_details( ).
    def_zrefx_central_re_coordin_2( ).

  ENDMETHOD.


  METHOD def_approval.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'APPROVAL'
                                    is_structure              = VALUE tys_approval( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'Approval' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'APPROVAL_SET' ).
    lo_entity_set->set_edm_name( 'ApprovalSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'EMP_EMAIL' ).
    lo_primitive_property->set_edm_name( 'EmpEmail' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LEGAL_REQUIRED' ).
    lo_primitive_property->set_edm_name( 'LegalRequired' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INDICATOR' ).
    lo_primitive_property->set_edm_name( 'Indicator' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 8 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'REQTYPE' ).
    lo_primitive_property->set_edm_name( 'Reqtype' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EMP_POSITION' ).
    lo_primitive_property->set_edm_name( 'EmpPosition' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PERNR' ).
    lo_primitive_property->set_edm_name( 'Pernr' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 8 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EMP_ORGID' ).
    lo_primitive_property->set_edm_name( 'EmpOrgid' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EMP_ORGNAME' ).
    lo_primitive_property->set_edm_name( 'EmpOrgname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRADE' ).
    lo_primitive_property->set_edm_name( 'Grade' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BEGDA' ).
    lo_primitive_property->set_edm_name( 'Begda' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ENDDA' ).
    lo_primitive_property->set_edm_name( 'Endda' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'AGENT' ).
    lo_primitive_property->set_edm_name( 'Agent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 8 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LEVEL' ).
    lo_primitive_property->set_edm_name( 'Level' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'NAME_1' ).
    lo_primitive_property->set_edm_name( 'Name1' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PNAME' ).
    lo_primitive_property->set_edm_name( 'Pname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ORGNAME' ).
    lo_primitive_property->set_edm_name( 'Orgname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EMAIL' ).
    lo_primitive_property->set_edm_name( 'Email' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNAME' ).
    lo_primitive_property->set_edm_name( 'Uname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CATEGORY' ).
    lo_primitive_property->set_edm_name( 'Category' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.

  ENDMETHOD.


  METHOD def_f_4_search_help.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'F_4_SEARCH_HELP'
                                    is_structure              = VALUE tys_f_4_search_help( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'F4SearchHelp' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'F_4_SEARCH_HELP_SET' ).
    lo_entity_set->set_edm_name( 'F4SearchHelpSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'FIELD' ).
    lo_primitive_property->set_edm_name( 'Field' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VALUE_1' ).
    lo_primitive_property->set_edm_name( 'Value1' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 15 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DESCR_1' ).
    lo_primitive_property->set_edm_name( 'Descr1' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 255 ) ##NUMBER_OK.

  ENDMETHOD.


  METHOD def_vendor_details.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'VENDOR_DETAILS'
                                    is_structure              = VALUE tys_vendor_details( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'VendorDetails' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'VENDOR_DETAILS_SET' ).
    lo_entity_set->set_edm_name( 'VendorDetailsSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'VENDOR_ID' ).
    lo_primitive_property->set_edm_name( 'VendorId' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VENDOR_NAME' ).
    lo_primitive_property->set_edm_name( 'VendorName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VENDOR_COMPANY_NAME' ).
    lo_primitive_property->set_edm_name( 'VendorCompanyName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VENDOR_MOB_NUMBER' ).
    lo_primitive_property->set_edm_name( 'VendorMobNumber' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VENDOR_EMAIL_ID' ).
    lo_primitive_property->set_edm_name( 'VendorEmailId' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VENDOR_ADDRESS' ).
    lo_primitive_property->set_edm_name( 'VendorAddress' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CONTACT_PERSON_NAME' ).
    lo_primitive_property->set_edm_name( 'ContactPersonName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VENDOR_REG_NUM' ).
    lo_primitive_property->set_edm_name( 'VendorRegNum' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.

  ENDMETHOD.


  METHOD def_zrefx_central_re_coordin_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZREFX_CENTRAL_RE_COORDIN_2'
                                    is_structure              = VALUE tys_zrefx_central_re_coordin_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ZREFX_CENTRAL_RE_COORDINATOR' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZREFX_CENTRAL_RE_COORDINAT' ).
    lo_entity_set->set_edm_name( 'ZREFX_CENTRAL_RE_COORDINATORSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'ORGEH' ).
    lo_primitive_property->set_edm_name( 'Orgeh' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 8 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PERNRS' ).
    lo_primitive_property->set_edm_name( 'Pernrs' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 300 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EMAILS' ).
    lo_primitive_property->set_edm_name( 'Emails' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 339 ) ##NUMBER_OK.

  ENDMETHOD.
ENDCLASS.
