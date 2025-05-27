CLASS zmhl_cl_custom_entity DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.

    TYPES: tt_header TYPE STANDARD TABLE OF zmhl_c_custom_header,
           tt_item   TYPE STANDARD TABLE OF zmhl_c_custom_item,
           tt_msg    TYPE STANDARD TABLE OF zmhl_c_custom_msg.

    CLASS-DATA: gt_header TYPE tt_header,
                gt_item   TYPE tt_item,
                gt_msg    TYPE tt_msg.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zmhl_cl_custom_entity IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: lt_header   TYPE STANDARD TABLE OF zmhl_c_custom_header,
          lt_item     TYPE STANDARD TABLE OF zmhl_c_custom_item,
          lt_msg      TYPE STANDARD TABLE OF zmhl_c_custom_msg,
          lv_order_by TYPE string.

    DATA: lt_filter_ranges_status TYPE RANGE OF ZMHL_C_Custom_Header-status,
          ls_filter_ranges_status LIKE LINE OF lt_filter_ranges_status.

    "Get Filters
    DATA(lt_filter_cond) =  io_request->get_filter( )->get_as_ranges( ).
    "-get filter for CATEGORY
    READ TABLE  lt_filter_cond WITH  KEY name = 'STATUS' INTO DATA(ls_status_cond).
    IF sy-subrc EQ 0.
      LOOP AT ls_status_cond-range INTO DATA(ls_sel_opt_status).
        MOVE-CORRESPONDING ls_sel_opt_status TO ls_filter_ranges_status.
        INSERT ls_filter_ranges_status INTO TABLE lt_filter_ranges_status.
      ENDLOOP.
    ENDIF.
***
***    "Get paging properties
***    DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
    "Get positive page size, to avoid -1
    DATA(lv_page_size) = abs( io_request->get_paging( )->get_page_size( ) ).
***
***    "Get sorting
***    DATA(lt_sort_elements) = io_request->get_sort_elements( ).
***    LOOP AT lt_sort_elements ASSIGNING FIELD-SYMBOL(<fs_sort_element>).
***      lv_order_by = |{ lv_order_by }{ COND #(
***                 WHEN <fs_sort_element>-descending = abap_false
***                 THEN |, { <fs_sort_element>-element_name }|
***                 ELSE |, { <fs_sort_element>-element_name } DESCENDING| ) }|.
***    ENDLOOP.
***    SHIFT lv_order_by BY 2 PLACES LEFT.

    "Get Parmeters
    DATA(lt_parameters) = io_request->get_parameters( ).

    "Get parameters for RFC
    DATA(lv_status)  =  VALUE #( lt_parameters[ parameter_name = 'P_PARAM1' ]-value OPTIONAL ).

    IF gt_header IS INITIAL.

      lt_header = VALUE #( ( headerid = 'RFC01' ) ).
      gt_header = lt_header.

      " Items for Return
      lt_item = VALUE #(
                   ( headerid = 'RFC01' item = '01' description = 'Item 1.1' )
                   ( headerid = 'RFC01' item = '02' description = 'Item 1.2' )
                   ( headerid = 'RFC01' item = '03' description = 'Item 1.3' ) ).
      gt_item = lt_item.

      " Msgs for Return
      lt_msg = VALUE #(
                   ( headerid = 'RFC01' item = '01' message = 'Success 1.1' )
                   ( headerid = 'RFC01' item = '02' message = 'Success 1.2' )
                   ( headerid = 'RFC01' item = '03' message = 'Error 1.3' ) ).
      gt_msg = lt_msg.

    ELSE.

      lt_header = gt_header.
      lt_item = gt_item.
      lt_msg = gt_msg.

    ENDIF.

    CASE io_request->get_entity_id( ).

      WHEN 'ZMHL_C_CUSTOM_HEADER'.
***        "Apply filter, get table with all results
***        SELECT * FROM @lt_header AS header
***        WHERE (lv_filter)
***        INTO TABLE @DATA(lt_header_result).
***
***        "Apply paging and sorting, get requested part of results
***        IF lv_order_by IS INITIAL.
***          lv_order_by = |HEADERID|.
***        ENDIF.
***        SELECT * FROM @lt_header_result AS header
***          ORDER BY (lv_order_by)
***          INTO TABLE @DATA(lt_requested_header)
***          UP TO @lv_page_size ROWS OFFSET @lv_offset.

        "set total count of results
        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( lines( lt_header ) ).
        ENDIF.
        "set data
        io_response->set_data( lt_header ).

      WHEN 'ZMHL_C_CUSTOM_ITEM'.

****        "Apply filter, get table with all results
****        SELECT * FROM @lt_item AS item
****          WHERE (lv_filter)
****          INTO TABLE @DATA(lt_item_result).
****
****        "Apply paging and sorting, get requested part of results
****        IF lv_order_by IS INITIAL.
****          lv_order_by = |ITEM|.
****        ENDIF.
****        SELECT * FROM @lt_item_result AS item
****         ORDER BY (lv_order_by)
****         INTO TABLE @DATA(lt_requested_item)
****         UP TO @lv_page_size ROWS OFFSET @lv_offset.

        "set total count of results
        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( lines( lt_item ) ).
        ENDIF.
        "set data
        io_response->set_data( lt_item ).

      WHEN 'ZMHL_C_CUSTOM_MSG'.

***        "Apply filter, get table with all results
***        SELECT * FROM @lt_msg AS msg
***          WHERE (lv_filter)
***          INTO TABLE @DATA(lt_msg_result).
***
***        "Apply paging and sorting, get requested part of results
***        IF lv_order_by IS INITIAL.
***          lv_order_by = |ITEM|.
***        ENDIF.
***        SELECT * FROM @lt_msg_result AS msg
***         ORDER BY (lv_order_by)
***         INTO TABLE @DATA(lt_requested_msg)
***         UP TO @lv_page_size ROWS OFFSET @lv_offset.

        "set total count of results
        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( lines( lt_msg ) ).
        ENDIF.
        "set data
        io_response->set_data( lt_msg ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
