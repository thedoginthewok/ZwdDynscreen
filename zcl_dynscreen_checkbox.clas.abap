CLASS zcl_dynscreen_checkbox DEFINITION PUBLIC INHERITING FROM zcl_dynscreen_parameter FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES:
      zif_dynscreen_uc_event.
    METHODS:
      constructor IMPORTING iv_text TYPE textpooltx OPTIONAL
                  RAISING   zcx_dynscreen_type_error,
      set_type REDEFINITION,
      set_value REDEFINITION.
    EVENTS:
      checkbox_clicked EXPORTING VALUE(ev_value) TYPE abap_bool OPTIONAL.
  PROTECTED SECTION.
    METHODS:
      generate_open REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DYNSCREEN_CHECKBOX IMPLEMENTATION.


  METHOD constructor.
* ---------------------------------------------------------------------
    super->constructor( iv_type = 'ABAP_BOOL'
                        iv_text = iv_text     ).

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD generate_open.
* ---------------------------------------------------------------------
    DATA:
      lv_default_value TYPE string.

* ---------------------------------------------------------------------
    IF mv_value IS NOT INITIAL.
      lv_default_value = ` ` && mc_syn-default && ` ` && mc_syn-sq && get_value( mc_conv_cast ) && mc_syn-sq.
    ENDIF.

* ---------------------------------------------------------------------
    APPEND
    mc_syn-param && ` ` && mc_syn-var_prefix && mv_id && ` ` && mc_syn-type && ` ` && mv_type && ` ` && mc_syn-chkbox &&
    lv_default_value && ` ` && mc_syn-ucomm && ` ` && mc_syn-ucm_prefix && mv_id && ` ` &&
    mc_syn-modif && ` ` && base10_to_22( mv_id ) && '.'
    TO mt_source.

* ---------------------------------------------------------------------
    APPEND `  IF sy-ucomm = '` && mc_syn-ucm_prefix && mv_id && `'. ` TO ms_source_eve-t_selscreen ##NO_TEXT.
    APPEND `    go_cb->raise_uc_event( exporting iv_id = '` && mv_id &&     ##NO_TEXT
           `' iv_value = ` && mc_syn-var_prefix && mv_id &&                 ##NO_TEXT
           ` changing cv_ucomm = sy-ucomm ).`  TO ms_source_eve-t_selscreen ##NO_TEXT .
    APPEND `  ENDIF.` TO ms_source_eve-t_selscreen ##NO_TEXT.

    DATA(lsy) = sy.
    RAISE EVENT checkbox_clicked.

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD set_type.
* ---------------------------------------------------------------------
    " not supported for checkboxes
    RETURN.

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD set_value.
* ---------------------------------------------------------------------
    IF iv_conversion = zwd_dynscreen_io_element=>mc_conv_cast.
      " only either iv_value or iv_value_str are allowed to be supplied
      " only abap_true and abap_false are allowed values
      IF  iv_value     IS SUPPLIED
      AND iv_value_str IS NOT SUPPLIED.
        IF  iv_value <> abap_true
        AND iv_value <> abap_false.
          RETURN.
        ENDIF.
      ELSEIF iv_value     IS NOT SUPPLIED
      AND    iv_value_str IS SUPPLIED.
        IF iv_value_str <> abap_true
        OR iv_value_str <> abap_false.
          RETURN.
        ENDIF.
      ELSE.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------
    super->set_value( iv_conversion = iv_conversion
                      iv_value      = iv_value
                      iv_value_str  = iv_value_str  ).

* ---------------------------------------------------------------------
  ENDMETHOD.


  METHOD zif_dynscreen_uc_event~raise.
* ---------------------------------------------------------------------
    FIELD-SYMBOLS:
      <lv_value> TYPE abap_bool.

* ---------------------------------------------------------------------
    ASSIGN md_value->* TO <lv_value>.
    RAISE EVENT checkbox_clicked EXPORTING ev_value = <lv_value>.

* ---------------------------------------------------------------------
  ENDMETHOD.
ENDCLASS.
