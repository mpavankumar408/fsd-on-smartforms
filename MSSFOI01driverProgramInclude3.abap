*----------------------------------------------------------------------*
*     Pflegetransaktion für Smart Forms
*     PAI Module
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       PAI des Einstiegsbildes
*----------------------------------------------------------------------*

module user_command_0100 input.
  perform user_command_0100.
endmodule.


form user_command_0100.

data: l_active      type tdbool,
      l_inactive    type tdbool.
data: l_fieldname   type scrfname,
      l_fcode_old   like sy-ucomm.
data: l_wb_request  type ref to cl_wb_request,
      l_wb_requestt type swbm_wb_request_set,
      l_wb_name     type seu_objkey,
      l_fpform_name type fpwbformname,
      l_fpintf_name type fpwbintfname,
      l_fp_runtime  type tdsfmtype,
      l_fp_ext_num  type balnrext,
      l_fp_column_sel type baldisp.

  l_fcode_old = fcode.
  clear fcode.

  case l_fcode_old.

* Abbrechen
  when c_fcode_cancel.
    leave program.

* Zurück
  when c_fcode_back.
    leave program.

* Beenden
  when c_fcode_exit.
    leave program.

* Smart Forms Homepage
  when 'PICK'.
    get cursor field l_fieldname.
    if l_fieldname eq 'SF_HOMEPAGE'.
      call function 'CALL_BROWSER'
           exporting   url    = 'http://smartforms.wdf.sap.corp:1080'
           exceptions others  = 1.
    endif.

* Anlegen
  when c_fcode_create.
    if rb_sf eq true.                                " Smart Form
      call function 'FB_CREATE_FORM'
           exporting i_formname    = ssfscreen-fname
                     i_formtype    = cssf_formtype_complete
                     i_with_dialog = space.
    elseif rb_st eq true.                            " Smart Style
      call function 'SSF_CREATE_STYLE'
           exporting i_stylename    = ssfscreens-sname
                     i_with_dialog  = space.
    elseif rb_tx eq true.                            " Smart Text
      call function 'FB_CREATE_FORM'
           exporting i_formname    = ssfscreen-tname
                     i_formtype    = cssf_formtype_text
                     i_with_dialog = space.
    endif.

* Ändern
  when c_fcode_change.
    if rb_sf eq true.                                " Smart Form
      call function 'FB_CHANGE_FORM'
           exporting i_formname    = ssfscreen-fname
                     i_formtype    = cssf_formtype_complete
                     i_with_dialog = space.
    elseif rb_st eq true.                            " Smart Style
      call function 'SSF_CHANGE_STYLE'
           exporting i_stylename    = ssfscreens-sname
                     i_with_dialog  = space.
    elseif rb_tx eq true.                            " Smart Text
      call function 'FB_CHANGE_FORM'
           exporting i_formname    = ssfscreen-tname
                     i_formtype    = cssf_formtype_text
                     i_with_dialog = space.
    endif.

* Anzeigen
  when c_fcode_display.
    if rb_sf eq true.                                " Smart Form
      call function 'FB_DISPLAY_FORM'
           exporting i_formname    = ssfscreen-fname
                     i_formtype    = cssf_formtype_complete
                     i_with_dialog = space.
    elseif rb_st eq true.                            " Smart Style
      call function 'SSF_DISPLAY_STYLE'
           exporting i_stylename    = ssfscreens-sname
                     i_with_dialog  = space.
    elseif rb_tx eq true.                            " Smart Text
      call function 'FB_DISPLAY_FORM'
           exporting i_formname    = ssfscreen-tname
                     i_formtype    = cssf_formtype_text
                     i_with_dialog = space.
    endif.

* Löschen
  when c_fcode_delete.
    if rb_sf eq true.                                " Smart Form
      call function 'FB_DELETE_FORM'
           exporting i_formname    = ssfscreen-fname
                     i_formtype    = cssf_formtype_complete
                     i_with_dialog = space.
    elseif rb_st eq true.                            " Smart Style
      call function 'SSF_DELETE_STYLE'
           exporting i_stylename    = ssfscreens-sname
                     i_with_dialog  = space.
    elseif rb_tx eq true.                            " Smart Text
      call function 'FB_DELETE_FORM'
           exporting i_formname    = ssfscreen-tname
                     i_formtype    = cssf_formtype_text
                     i_with_dialog = space.
    endif.

* Kopieren
  when c_fcode_copy.
    if rb_sf eq true.                                " Smart Form
      call function 'FB_COPY_FORM'
           exporting i_formname_old = ssfscreen-fname
                     i_formname_new = ssfscreen-fname_new
           importing o_formname_new = ssfscreen-fname.
    elseif rb_st eq true.                            " Smart Style
      call function 'SSF_COPY_STYLE'
           exporting i_stylename_old = ssfscreens-sname
                     i_stylename_new = ssfscreens-sname_new
           importing o_stylename_new = ssfscreens-sname.
    elseif rb_tx eq true.                            " Smart Text
      call function 'FB_COPY_FORM'
           exporting i_formname_old = ssfscreen-tname
                     i_formname_new = ssfscreen-fname_new
           importing o_formname_new = ssfscreen-tname.
    endif.

* Umbenennen
  when c_fcode_rename.
    if rb_sf eq true.                                " Smart Form
      call function 'FB_RENAME_FORM'
           exporting i_formname_old = ssfscreen-fname
                     i_formname_new = ssfscreen-fname_new
           importing o_formname_new = ssfscreen-fname.
    elseif rb_st eq true.                            " Smart Style
      call function 'SSF_RENAME_STYLE'
           exporting i_stylename_old = ssfscreens-sname
                     i_stylename_new = ssfscreens-sname_new
           importing o_stylename_new = ssfscreens-sname.
    elseif rb_tx eq true.                            " Smart Text
      call function 'FB_RENAME_FORM'
           exporting i_formname_old = ssfscreen-tname
                     i_formname_new = ssfscreen-fname_new
           importing o_formname_new = ssfscreen-tname.
    endif.

* Paketzuordnung ändern
  when c_fcode_change_devc.
    if rb_sf eq true.                                " Smart Form
      call function 'FB_CHANGE_DEVC'
           exporting  i_formname    = ssfscreen-fname
                      i_with_dialog = space
           importing  o_formname    = ssfscreen-fname
           exceptions canceled      = 1
                      failed        = 2
                      others        = 3.
    elseif rb_st eq true.                            " Smart Style
      call function 'SSF_CHANGE_DEVC_STYLE'
           exporting  i_stylename   = ssfscreens-sname
                      i_with_dialog = space
           importing  o_stylename   = ssfscreens-sname
           exceptions cancelled     = 1
                      failed        = 2
                      others        = 3.
    elseif rb_tx eq true.                            " Smart Text
      call function 'FB_CHANGE_DEVC'
           exporting  i_formname    = ssfscreen-tname
                      i_with_dialog = space
           importing  o_formname    = ssfscreen-tname
           exceptions canceled      = 1
                      failed        = 2
                      others        = 3.
    endif.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

* Hochladen
  when c_fcode_upload.
    if rb_sf eq true.                                " Smart Form
      call function 'FB_UPLOAD_FORM'
           exporting i_formname    = ssfscreen-fname
                     i_formtype    = cssf_formtype_complete
                     i_with_dialog = 'X'
           importing o_formname    = ssfscreen-fname.
    elseif rb_st eq true.                            " Smart Style
      call function 'SSF_UPLOAD_STYLE'
           exporting i_stylename   = ssfscreens-sname
                     i_with_dialog = 'X'
           importing o_stylename   = ssfscreens-sname.
    elseif rb_tx eq true.                            " Smart Text
      call function 'FB_UPLOAD_FORM'
           exporting i_formname    = ssfscreen-tname
                     i_formtype    = cssf_formtype_text
                     i_with_dialog = 'X'
           importing o_formname    = ssfscreen-tname.
    endif.

* Herunterladen
  when c_fcode_download.
    if rb_sf eq true.                                " Smart Form
      call function 'FB_DOWNLOAD_FORM'
           exporting i_formname    = ssfscreen-fname
                     i_formtype    = cssf_formtype_complete
                     i_with_dialog = 'X'
           importing o_formname    = ssfscreen-fname.
    elseif rb_st eq true.                            " Smart Style
      call function 'SSF_DOWNLOAD_STYLE'
           exporting i_stylename   = ssfscreens-sname
                     i_with_dialog = 'X'
           importing o_stylename   = ssfscreens-sname.
    elseif rb_tx eq true.                            " Smart Text
      call function 'FB_DOWNLOAD_FORM'
           exporting i_formname    = ssfscreen-tname
                     i_formtype    = cssf_formtype_text
                     i_with_dialog = 'X'
           importing o_formname    = ssfscreen-tname.
    endif.

* --- Smart Forms specific fcodes ---
* Generieren (Smart Form)
  when c_fcode_generate.
    call function 'FB_GENERATE_FORM'
         exporting  i_formname = ssfscreen-fname.

* Migrieren von SAPscript
  when c_fcode_migrate.
    call function 'FB_MIGRATE_FORM'
         exporting  i_formname_smartform = ssfscreen-fname
         importing  o_formname_smartform = ssfscreen-fname.

* Migrieren zum Kontext/XFT
  when c_fcode_migrate_fpexport.
    cl_ssf_fp_cust=>get_runtime_setting(
                        exporting sfname   = ssfscreen-fname
                        importing destname = l_fpform_name ).
    try.
      l_fpintf_name = cl_fp_wb_helper=>form_which_interface_used( l_fpform_name ).
    catch cx_fp_api_usage.
      clear l_fpintf_name.
    catch cx_fp_api_repository.
      clear l_fpintf_name.
    endtry.
    call function 'FB_MIGRATE_FORM_FP_DEF'
         exporting i_smartform_name           = ssfscreen-fname
                   i_fpform_name              = l_fpform_name
                   i_fpintf_name              = l_fpintf_name
*                  i_with_dialog              = 'X'
         importing o_smartform_name           = ssfscreen-fname.
*                  o_fpform_name              = l_fpform_name
*                  o_fpintf_name              = l_fpintf_name.

  when c_fcode_migrate_fplog.
    l_fp_ext_num = ssfscreen-fname.

    l_fp_column_sel-number     = '1'.
    l_fp_column_sel-object     = '1'.
    l_fp_column_sel-subobject  = '1'.
    l_fp_column_sel-ext_number = '1'.
    l_fp_column_sel-date       = '2'.
    l_fp_column_sel-time       = '2'.
    l_fp_column_sel-user       = '2'.
    l_fp_column_sel-probclass  = '2'.

    call function 'APPL_LOG_DISPLAY'
         exporting  object                    = cl_ssf_migration=>c_log_sf_object
                    subobject                 = cl_ssf_migration=>c_log_sf_subobject
                    external_number           = l_fp_ext_num
*                   date_from                 =
*                   time_from                 =
*                   date_to                   = sy-datum
*                   time_to                   = sy-uzeit
*                   title_selection_screen    = ' '
*                   title_list_screen         = ' '
                    column_selection          = l_fp_column_sel
                    suppress_selection_dialog = 'X'
         exceptions others = 0.

  when c_fcode_migrate_fpedit.
    cl_ssf_fp_cust=>get_runtime_setting(
                        exporting sfname   = ssfscreen-fname
                        importing destname = l_fpform_name ).
    if l_fpform_name is initial.
      l_fpform_name = ssfscreen-fname.
    endif.
    try.
      l_fpintf_name = cl_fp_wb_helper=>form_which_interface_used( l_fpform_name ).
    catch cx_fp_api_usage.
      clear l_fpintf_name.
    catch cx_fp_api_repository.
      clear l_fpintf_name.
    endtry.
    set parameter id 'FPWBFORM'      field l_fpform_name.
    set parameter id 'FPWBINTERFACE' field l_fpintf_name.
    clear l_wb_requestt[].
    l_wb_name = l_fpform_name.
    create object l_wb_request
           exporting p_object_type  = swbm_c_type_formobject_form
*                    p_object_type  = swbm_c_type_formobject_intf
                     p_object_name  = l_wb_name
                     p_operation    = swbm_c_op_initial_screen.   " swbm_c_op_edit.
    append l_wb_request to l_wb_requestt.
    cl_wb_startup=>start( p_wb_request_set = l_wb_requestt ).

  when c_fcode_migrate_fpswitch.
    cl_ssf_fp_cust=>get_runtime_setting(
                        exporting sfname   = ssfscreen-fname
                        importing destname = l_fpform_name
                                  type     = l_fp_runtime ).
    call function 'FB_MIGRATE_FORM_FP_CUST'
         exporting i_smartform_name           = ssfscreen-fname
                   i_fpform_name              = l_fpform_name
                   i_runtime                  = l_fp_runtime
*                  i_with_dialog              = 'X'
         importing o_smartform_name           = ssfscreen-fname.
*                  o_fpform_name              =
*                  o_runtime                  =


* Benutzereinstellungen ändern
  when c_fcode_settings.
    call function 'FB_CHANGE_OPTIONS'.

* Testen
  when c_fcode_test.
    if ssfscreen-fname = space.
      message e206.
    endif.
    call function 'SSF_STATUS_INFO'
      exporting
        i_formname       = ssfscreen-fname
      importing
        o_active         = l_active
        o_inactive       = l_inactive.
    if l_active = false and l_inactive = true.
      message e209 with ssfscreen-fname.
    endif.
    call function 'SSF_FUNCTION_MODULE_NAME'
         exporting  formname           = ssfscreen-fname
         importing  fm_name            = fm_name
         exceptions no_form            = 1
                    no_function_module = 2
                    others             = 3.
    case sy-subrc.
    when 1. message e200 with ssfscreen-fname.
    when 2. message e210 with ssfscreen-fname.
    endcase.
    set parameter id 'LIB' field fm_name.
    call transaction 'SE37' with authority-check.

* Anzeige der Internform
  when c_fcode_dump.
    call function 'SSFHLP_SHOW_FORM_INTERNAL'
         exporting  i_formname         = ssfscreen-fname
                    i_active           = 'X'
         exceptions cancelled          = 1
                    locked             = 2
                    no_form            = 3
                    no_active_source   = 4
                    no_inactive_source = 5
                    others             = 6.
    case sy-subrc.
    when 1.
    when 2. message e202 with ssfscreen-fname.
    when 3. message e200 with ssfscreen-fname.
    when 4. message e209 with ssfscreen-fname.
    when 5. message e199 with ssfscreen-fname.
    endcase.

* --- Smart Styles specific fcodes ---
* Aktivieren
  when c_fcode_activate.
    call function 'SSF_ACTIVATE_STYLE'
         exporting  i_stylename          = ssfscreens-sname
         importing  o_stylename          = ssfscreens-sname
         exceptions others               = 1.
    if sy-subrc ne 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

* Prüfen
  when c_fcode_check.
    call function 'SSF_CHECK_STYLE'
         exporting  i_stylename          = ssfscreens-sname
         importing  o_stylename          = ssfscreens-sname.

* SAPscript-Stil importieren
  when c_fcode_convert.
    call function 'SSF_IMPORT_SAPSCRIPT_STYLE'
         exporting i_stylename    = ssfscreens-sname
                   i_with_dialog  = 'X'
         importing o_stylename    = ssfscreens-sname.

* Fontersetzung für Stile
  when c_fcode_replace_fonts.
    call transaction 'SM30_STXSFREPL' with authority-check.

  endcase.                 " fcode

endform.                 " USER_COMMAND_0100