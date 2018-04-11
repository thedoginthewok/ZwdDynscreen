CLASS zcl_dynscreen_button DEFINITION PUBLIC INHERITING FROM zcl_dynscreen_io_element FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING iv_text   TYPE textpooltx OPTIONAL
                            iv_pos    TYPE i OPTIONAL
                            iv_length TYPE i OPTIONAL
                  RAISING   zcx_dynscreen_type_error,
      set_position IMPORTING iv_pos TYPE i,
      get_position RETURNING VALUE(rv_pos) TYPE i,
      set_length IMPORTING iv_length TYPE i,
      get_length RETURNING VALUE(rv_length) TYPE i,
      raise_event REDEFINITION.
    EVENTS:
      button_click.
  PROTECTED SECTION.
    METHODS:
      generate_open REDEFINITION,
      generate_close REDEFINITION.
  PRIVATE SECTION.
    TYPES:
      mty_n2 TYPE n LENGTH 2.
    DATA:
      mv_position TYPE mty_n2,
      mv_length   TYPE mty_n2.

ENDCLASS.



CLASS zcl_dynscreen_button IMPLEMENTATION.


  METHOD constructor.
* ---------------------------------------------------------------------
    super->constructor( iv_type         = mc_type_generic
                        is_generic_type = VALUE #( datatype = mc_type-c length = 1 )
                        iv_text         = iv_text                                    ).

* ---------------------------------------------------------------------
    "zcx_dynscreen_type_error.
    mv_is_variable = abap_false.
    set_position( iv_pos ).
    IF iv_length IS NOT SUPPLIED.
      set_length( 8 ).
    ELSE.
      set_length( iv_length ).
    ENDIF.

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD generate_close ##NEEDED.
* ---------------------------------------------------------------------
* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD generate_open.
* ---------------------------------------------------------------------
    APPEND mc_syn-selscreen && ` SKIP 1.` TO mt_source.
    APPEND mc_syn-selscreen && ` ` && mc_syn-button && ` ` && mv_position && `(` && mv_length && `) ` &&
           mc_syn-btn_prefix && mv_id && ` ` && mc_syn-ucomm && ` ` && mc_syn-ucm_prefix && mv_id &&
           ` ` && mc_syn-modif && ` ` && base10_to_22( mv_id ) && '.' TO mt_source.

* ---------------------------------------------------------------------
    " add event handling code
    APPEND `  IF sy-ucomm = '` && mc_syn-ucm_prefix && mv_id && `'. ` TO ms_source_eve-t_selscreen.
    APPEND `    go_cb->raise_event( exporting iv_id = '` && mv_id &&
           `' changing cv_ucomm = sy-ucomm ).` TO ms_source_eve-t_selscreen.
    APPEND '  ENDIF.' TO ms_source_eve-t_selscreen.

* ---------------------------------------------------------------------
    IF mv_text IS NOT INITIAL.
      APPEND mc_syn-btn_prefix && mv_id && ` = '` && mv_text && `'.` TO ms_source_eve-t_init.
    ENDIF.

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD get_length.
* ---------------------------------------------------------------------
    rv_length = mv_length.

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD get_position.
* ---------------------------------------------------------------------
    rv_pos = mv_position.

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD raise_event.
* ---------------------------------------------------------------------
    RAISE EVENT button_click.

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD set_length.
* ---------------------------------------------------------------------
    IF iv_length < 1.
      mv_length = 1.
    ELSEIF iv_length > 83.
      mv_length = 83.
    ELSE.
      mv_length = iv_length.
    ENDIF.

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD set_position.
* ---------------------------------------------------------------------
    IF iv_pos < 1.
      mv_position = 1.
    ELSEIF iv_pos > 83.
      mv_position = 83.
    ELSE.
      mv_position = iv_pos.
    ENDIF.

* ---------------------------------------------------------------------
  ENDMETHOD.
ENDCLASS.
