CLASS zcl_ce_sys_messages DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CE_SYS_MESSAGES IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA ls_message type string.
    DATA lt_message TYPE TABLE OF zce_sys_messages.
    DATA(top)               = io_request->get_paging( )->get_page_size( ).
    DATA(skip)              = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)        = io_request->get_sort_elements( ).

    TRY.
        DATA(filter_condition) = io_request->get_filter( )->get_as_ranges( ).

        CALL FUNCTION 'Z_GET_SYSTEM_MESSAGES'
          IMPORTING
            msg = ls_message
          .

        append value #( sys_message = ls_message ) to lt_message.

        io_response->set_data( lt_message ).

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
