CLASS lsc_zmn_i_buildings DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zmn_i_buildings IMPLEMENTATION.

*  this method using the late numbering concept to assign the building id for the entity
*  using number range object
  METHOD adjust_numbers.

    DATA lv_bldg_num TYPE n LENGTH 5.

    LOOP AT mapped-building ASSIGNING FIELD-SYMBOL(<map_building>) WHERE %key-BuildingId IS INITIAL .
      TRY.
*          using number range to generate the building id
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = 'N1'
              object            = 'ZNR_BLD_NO'
              quantity          = 1
            IMPORTING
              number            = DATA(number)
              returncode        = DATA(ret_code)
              returned_quantity = DATA(ret_qty)
          ).
          lv_bldg_num = number.
          <map_building>-%key-BuildingId = |B{ lv_bldg_num }|.
        CATCH cx_nr_object_not_found cx_number_ranges INTO DATA(lox_exp).
          APPEND VALUE #(
              %key = <map_building>-%key
              %msg = lox_exp
          ) TO reported-building.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Building DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Building RESULT result.

    METHODS validateNRooms FOR VALIDATE ON SAVE
      IMPORTING keys FOR Building~validateNRooms.

ENDCLASS.

CLASS lhc_Building IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  method to validate the no of rooms field
  METHOD validateNRooms.

*    reading the building entites
    READ ENTITIES OF zmn_i_buildings IN LOCAL MODE
        ENTITY Building
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(buildings)
        FAILED DATA(building_failed).

    IF building_failed IS NOT INITIAL.
*     if the above read fails then return the error message
      failed = CORRESPONDING #( DEEP building_failed ).
      RETURN.
    ENDIF.

    LOOP AT buildings ASSIGNING FIELD-SYMBOL(<building>).

      IF NOT <building>-NRooms BETWEEN 1 AND 10.

*        if bulk upload, then the excel row no field will not be initial,
*        creating a message prefix for the output message
        DATA(lv_msg) = |No of Rooms must be in Range 1 to 10|.
        lv_msg = COND #( WHEN <building>-ExcelRowNumber IS INITIAL
            THEN lv_msg
            ELSE |Row { <building>-ExcelRowNumber }: { lv_msg }|
          ).

        APPEND VALUE #(
            %tky = <building>-%tky
        ) TO failed-building.

        APPEND VALUE #(
            %tky            = <building>-%tky
            %state_area     = 'Validate_Rooms'
            %msg            = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = lv_msg
            )
            %element-NRooms = if_abap_behv=>mk-on
        ) TO reported-building.
      ENDIF.

      CLEAR lv_msg.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
