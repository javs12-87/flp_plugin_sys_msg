CLASS zget_sys_msg DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_aco_proxy .

    METHODS constructor
      IMPORTING
        !destination TYPE REF TO if_rfc_dest
      RAISING
        cx_rfc_dest_provider_error .
    METHODS z_get_system_messages
      EXPORTING
        !msg TYPE string
      RAISING
        cx_aco_application_exception
        cx_aco_communication_failure
        cx_aco_system_failure .
  PROTECTED SECTION.

    DATA destination TYPE rfcdest .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZGET_SYS_MSG IMPLEMENTATION.


  METHOD constructor.
    me->destination = destination->get_destination_name( ).
  ENDMETHOD.


  METHOD z_get_system_messages.
    DATA: _rfc_message_ TYPE char255.
    CALL FUNCTION 'Z_GET_SYSTEM_MESSAGES' DESTINATION me->destination
      IMPORTING
        msg                   = msg
      EXCEPTIONS
        communication_failure = 1 MESSAGE _rfc_message_
        system_failure        = 2 MESSAGE _rfc_message_
        OTHERS                = 3.
    IF sy-subrc NE 0.
      DATA __sysubrc TYPE sy-subrc.
      DATA __textid TYPE scx_t100key.
      __sysubrc = sy-subrc.
      __textid-msgid = sy-msgid.
      __textid-msgno = sy-msgno.
      __textid-attr1 = sy-msgv1.
      __textid-attr2 = sy-msgv2.
      __textid-attr3 = sy-msgv3.
      __textid-attr4 = sy-msgv4.
      CASE __sysubrc.
        WHEN 1 .
          RAISE EXCEPTION TYPE cx_aco_communication_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 2 .
          RAISE EXCEPTION TYPE cx_aco_system_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 3 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'OTHERS'
              textid       = __textid.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
