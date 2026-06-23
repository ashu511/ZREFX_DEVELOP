CLASS zsam_rap_dummy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS c_object TYPE cl_numberrange_objects=>nr_attributes-object
*      VALUE 'ZREFX_CMNR'.   "Your number-range object
       VALUE 'ZREFX_CLNR'.   "Your number-range object


    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsam_rap_dummy IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*--------------Number range changes-------------------*
    DATA: io_out TYPE REF TO if_oo_adt_classrun_out.
    DATA: lv_nrrangenr(2) TYPE c.
    DATA: lv_fromnumber(6) TYPE c.
    DATA: lv_tonumber(6) TYPE c.
    DATA: lv_procind(1) TYPE c.
    lv_nrrangenr  = '01'.
    lv_fromnumber = '250000'.
    lv_tonumber   = '999999'.
    lv_procind    = 'I'.
    "Create interval only if not existing
    TRY.

        cl_numberrange_intervals=>create(
          EXPORTING
            object   = c_object
            interval = VALUE #(
                         ( nrrangenr  = lv_nrrangenr  "'01'
                           fromnumber = lv_fromnumber       "'250000'
                           tonumber   = lv_tonumber         "'999999'
                           procind    = lv_procind "'I'

                           )
                       )
        ).


      CATCH cx_root INTO DATA(lx_error).
        RAISE SHORTDUMP lx_error.
    ENDTRY.
*--------------Number range changes-------------------*
*    SELECT * FROM zrefx_d_att_comp  INTO TABLE @DATA(lt_data1).
*    out->write(
*        EXPORTING
*            data = lt_data1
*            name = 'Output Title'
*    ).
*
*        SELECT * FROM zrefx_config  INTO TABLE @DATA(lt_data5).
*    out->write(
*        EXPORTING
*            data = lt_data1
*            name = 'Output Title'
*    ).


*    SELECT * FROM zrefx_draft_comp INTO TABLE @DATA(lt_data2).
*    out->write(
*        EXPORTING
*            data = lt_data2
*            name = 'Output Title'
*    ).
*
*    SELECT * FROM zrefx_complaints INTO TABLE @DATA(lt_data3).
*    out->write(
*        EXPORTING
*            data = lt_data3
*            name = 'Output Title'
*    ).
*
*    SELECT * FROM zrefx_att_comp INTO TABLE @DATA(lt_data4).
*    out->write(
*        EXPORTING
*            data = lt_data4
*            name = 'Output Title'
*    ).

*DELETE FROM zrefx_claims.
*    DELETE FROM zrefx_complaints.
*    DELETE FROM zrefx_draft_comp.
*    DELETE FROM zrefx_att_comp.
*    DELETE FROM zrefx_d_att_comp.
*delete fROM zrefx_complaints wHERE complaint_id = 'CMP2026250038'.
*
  ENDMETHOD.
ENDCLASS.
