CLASS zcl_complaint_upload DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
  METHODS: Upload_data.
ENDCLASS.



CLASS zcl_complaint_upload IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    upload_data( ).
  ENDMETHOD.

  METHOD upload_data.
    "Your upload logic will go here
  ENDMETHOD.
ENDCLASS.
