*&---------------------------------------------------------------------*
*&      Pflegetransaktion für Smart Forms
*&      Datendefinitionen
*&---------------------------------------------------------------------*

program sapmssfo message-id smartforms.

tables: ssfscreen, ssfscreens.

type-pools: cssf,
            swbm.

* INCLUDES
include rstxsfcdef.

* Beschreibung des Einstiegsbildes
constants: c_screen_main  like sy-dynnr value '0100',
           c_status_main  like sy-pfkey value 'MAIN',
           c_status_style like sy-pfkey value 'STYLE',
           c_status_text  like sy-pfkey value 'TEXT',
           c_title_main   like sy-title value 'MAIN'.

* loop at screen
constants: screen_on(1)  type c value '1',
           screen_off(1) type c value '0'.

types: ty_excludes_tab type standard table of fcode with default key.

data:  fcode     like sy-ucomm.

data: fm_name type funcname.           " Name des Funktionsbausteins

constants: true(1)   type c value 'X',       " TRUE
           false(1)  type c value ' '.       " FALSE

data:      sf_homepage(255)     type c.

* Smart Forms fcodes
constants: c_fcode_cancel        type fcode value 'CANCEL',
           c_fcode_back          type fcode value 'BACK',
           c_fcode_exit          type fcode value 'EXIT',
           c_fcode_create        type fcode value 'CREATE',
           c_fcode_change        type fcode value 'CHANGE',
           c_fcode_display       type fcode value 'DISPLAY',
           c_fcode_delete        type fcode value 'DELETE',
           c_fcode_copy          type fcode value 'COPY',
           c_fcode_rename        type fcode value 'RENAME',
           c_fcode_generate      type fcode value 'GENERATE',
           c_fcode_change_devc   type fcode value 'CH_DEVC',
           c_fcode_upload        type fcode value 'XMLUP',
           c_fcode_download      type fcode value 'XMLDOWN',
           c_fcode_settings      type fcode value 'SETTING',
           c_fcode_test          type fcode value 'TEST',
           c_fcode_dump          type fcode value 'DUMP',

*          Migration specifc fcodes
           c_fcode_migrate          type fcode value 'MIGRATE',     " import SAPscript Form
           c_fcode_migrate_fpexport type fcode value 'FPEXPORT', " export SF to FP
           c_fcode_migrate_fplog    type fcode value 'FPLOG',    " display migration log
           c_fcode_migrate_fpedit   type fcode value 'FPEDIT',   " transaction sfp
           c_fcode_migrate_fpswitch type fcode value 'FPSWITCH', " switch between FP/SF runtime

*          Smart Styles specific fcodes
           c_fcode_activate      type fcode value 'ACTIVATE',
           c_fcode_convert       type fcode value 'CONVERT',
           c_fcode_replace_fonts type fcode value 'FONTREPL',
           c_fcode_check         type fcode value 'CHECK'.

* Smart Styles specific fcodes

data: rb_sf type tdsfflag,
      rb_st type tdsfflag,
      rb_tx type tdsfflag.

data: logo_container type ref to cl_gui_custom_container,
      logo           type ref to cl_gui_picture.
data: url(255) type c.

*--- Macros ---
define screen_display.
  loop at screen.
    check screen-name = &1.
    screen-input     = screen_off.
    modify screen.
  endloop.
end-of-definition.
*
define screen_invisible.
  loop at screen.
    check screen-name = &1.
    screen-invisible  = screen_on.
    screen-input      = screen_off.
    modify screen.
  endloop.
end-of-definition.