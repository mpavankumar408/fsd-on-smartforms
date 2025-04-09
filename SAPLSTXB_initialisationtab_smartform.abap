DATA: ls_txt   TYPE /SCWM/S_SP_A_HEAD_TEXT,
      lv_tstmp TYPE timestamp.

*get documentID
gv_docid = is_dlv_note-hd_gen-docid.

CLEAR: gs_header_txt,
       gs_footer_txt.

*calculate printout date and time for warehouse time zone
CONVERT DATE sy-datlo TIME sy-timlo
        INTO TIME STAMP lv_tstmp
        TIME ZONE sy-zonlo.

CONVERT TIME STAMP lv_tstmp TIME ZONE iv_tzone
        INTO DATE gv_act_date
             TIME gv_act_time.

*get header and footer text

* customer specific selection for header text:
*READ TABLE is_dlv_note-hd_text WITH KEY docid = gv_docid
*                                        description =
*                               INTO gs_header_txt.
*
* customer specific selection for footer text:
*READ TABLE is_dlv_note-hd_text WITH KEY docid = gv_docid
*                                        description =
*                               INTO gs_footer_txt.
*
* default selection:
*  first entry in interface table IS_DLV_NOTE-HD_TXT is header text,
*  second entry in interface table IS_DLV_NOTE-HD_TXT is footer text
LOOP AT is_dlv_note-hd_text INTO ls_txt.
  IF gs_header_txt IS INITIAL.
    gs_header_txt = ls_txt.
  ELSEIF gs_footer_txt IS INITIAL.
    gs_footer_txt = ls_txt.
    EXIT.
  ENDIF.
ENDLOOP.







