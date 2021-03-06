REPORT zwd_dynscreen_test2_popup.

CLASS lcl_appl DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS process.
  PRIVATE SECTION.
    METHODS handle_button_click FOR EVENT button_click OF zcl_dynscreen_button.
ENDCLASS.

NEW lcl_appl( )->process( ).


CLASS lcl_appl IMPLEMENTATION.

  METHOD process.
* ---------------------------------------------------------------------
    DATA:
      lo_popup     TYPE REF TO zcl_dynscreen_popup,
      lo_btn       TYPE REF TO zcl_dynscreen_button,
      lo_pa_matnr1 TYPE REF TO zcl_dynscreen_parameter,
      lo_pa_matnr2 TYPE REF TO zcl_dynscreen_parameter,
      lo_so_vbeln  TYPE REF TO zcl_dynscreen_selectoption,
      lo_pa_ebeln  TYPE REF TO zcl_dynscreen_parameter,
      lx           TYPE REF TO cx_root.

* ---------------------------------------------------------------------
    lo_popup = NEW #( ).
    lo_popup->set_pretty_print( ).
    lo_popup->set_text( 'Selection Screen Generation Test' ).

    TRY.
        lo_pa_matnr1 = NEW #( io_parent = lo_popup
                              iv_type   = 'MARA-MATNR' ).
        lo_pa_matnr1->set_value( 'DEFAULT' ).
        lo_pa_matnr2 = NEW #( io_parent = lo_popup
                              iv_type   = 'MARA-MATNR' ).
        lo_pa_matnr1->set_text( lo_pa_matnr1->get_text( ) && ` ` && '1' ).
        lo_pa_matnr2->set_text( lo_pa_matnr2->get_text( ) && ` ` && '2' ).
      CATCH zcx_dynscreen_type_error
            zcx_dynscreen_value_error
            zcx_dynscreen_incompatible
            zcx_dynscreen_too_many_elems INTO lx.
        MESSAGE lx TYPE 'E'.
    ENDTRY.

    TRY.
        lo_btn = NEW #( io_parent = lo_popup
                        iv_text   = 'Testbutton'
                        iv_length = 20           ).
        SET HANDLER handle_button_click FOR lo_btn.


        lo_so_vbeln = NEW #( io_parent = lo_popup
                             iv_type   = 'VBAK-VBELN' ).

        lo_pa_ebeln = NEW #( io_parent = lo_popup
                             iv_type   = 'EKKO-EBELN' ).

      CATCH zcx_dynscreen_type_error
            zcx_dynscreen_incompatible
            zcx_dynscreen_too_many_elems INTO lx.
        MESSAGE lx TYPE 'E'.
    ENDTRY.


    TRY.
        lo_popup->display( ).
* ---------------------------------------------------------------------
        " ev_value is "type any"
        DATA lv_matnr1 TYPE mara-matnr.
        lo_pa_matnr1->get_value( IMPORTING ev_value = lv_matnr1 ).

* ---------------------------------------------------------------------
        " all io elements have a generated variable reference held internally
        " which can be accessed with method GET_VALUE_REF
        FIELD-SYMBOLS <lv_matnr2> TYPE mara-matnr.
        DATA(lv_matnr2_ref) = lo_pa_matnr2->get_value_ref( ).
        ASSIGN lv_matnr2_ref->* TO <lv_matnr2>.

* ---------------------------------------------------------------------
        DATA lr_vbeln TYPE RANGE OF vbak-vbeln.
        lo_so_vbeln->get_value( IMPORTING ev_value = lr_vbeln ).

* ---------------------------------------------------------------------
        " method GET_VALUE also has a returning parameter of type string
        " if the io element is not of type string, using this will cause two type conversions
        " in this case:
        " internal value of type EKKO-EBELN cast to string -> string cast to LV_EBELN of type EKKO_EBELN
        DATA lv_ebeln TYPE ekko-ebeln.
        lv_ebeln = lo_pa_ebeln->get_value( ).


* ---------------------------------------------------------------------
        WRITE: `lo_pa_matnr1: `, lv_matnr1, /.

        WRITE: `lo_pa_matnr2: `, <lv_matnr2>, /.

        WRITE: 'lo_so_vbeln:', /.
        LOOP AT lr_vbeln ASSIGNING FIELD-SYMBOL(<lrs_vbeln>).
          WRITE: <lrs_vbeln>-sign, ` `, <lrs_vbeln>-option, ` `, <lrs_vbeln>-low, ` `, <lrs_vbeln>-high, /.
        ENDLOOP.
        WRITE /.

        WRITE: `lo_pa_ebeln: `, lv_ebeln, /.

      CATCH zcx_dynscreen_canceled INTO lx.
        MESSAGE lx TYPE 'S' DISPLAY LIKE 'E'.
      CATCH zcx_dynscreen_syntax_error
            zcx_dynscreen_value_error INTO lx.
        MESSAGE lx TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD handle_button_click.
* ---------------------------------------------------------------------
    MESSAGE 'Button pressed!' TYPE 'I'.

* ---------------------------------------------------------------------
  ENDMETHOD.

ENDCLASS.
