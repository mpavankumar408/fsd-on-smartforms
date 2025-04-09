*----------------------------------------------------------------------*
*     Pflegetransaktion für Smart Forms
*     PBO Module
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       PBO des Einstiegsbildes
*----------------------------------------------------------------------*
module status_0100 output.

  if rb_sf eq true.
    set pf-status c_status_main.
    screen_display:  'SSFSCREENS-SNAME', 'SSFSCREEN-TNAME'.
    set cursor field 'SSFSCREEN-FNAME'.
  elseif rb_st eq true.
    set pf-status c_status_style.
    screen_display:  'SSFSCREEN-FNAME',  'SSFSCREEN-TNAME'.
    set cursor field 'SSFSCREENS-SNAME'.
  elseif rb_tx eq true.
    set pf-status c_status_text.
    screen_display:  'SSFSCREEN-FNAME',  'SSFSCREENS-SNAME'.
    set cursor field 'SSFSCREEN-TNAME'.
  else.
    set pf-status c_status_main.
    screen_display:  'SSFSCREENS-SNAME', 'SSFSCREEN-TNAME'.
    set cursor field 'SSFSCREEN-FNAME'.
  endif.

  set titlebar c_title_main.
  clear fcode.

  sf_homepage = 'Smart Forms Homepage'.                      "#EC NOTEXT
  perform display_homepage.

endmodule.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  INIT_PICTURE_CONTROL  OUTPUT
*&---------------------------------------------------------------------*
*       PBO des Einstiegsbildes
*----------------------------------------------------------------------*
module init_picture_control output.
  perform init_picture_control.
endmodule.                 " INIT_PICTURE_CONTROL  OUTPUT

*&---------------------------------------------------------------------*
*&      Form  init_picture_control
*&---------------------------------------------------------------------*
form init_picture_control.

data: query_table like w3query occurs 1 with header line,
      html_table like w3html occurs 1,
      return_code like  w3param-ret_code,
      content_type like  w3param-cont_type,
      content_length like  w3param-cont_len,
      pic_data like w3mime occurs 0,
      pic_size type i.

  if url is initial.

    if logo_container is initial.
      create object logo_container
             exporting  container_name = 'LOGO_CONTAINER'
             exceptions others         = 1.
      if sy-subrc ne 0.
        exit.
      endif.
    endif.

    if logo is initial.
      create object logo
             exporting  parent = logo_container
             exceptions others = 1.
      if sy-subrc ne 0.
        exit.
      endif.
    endif.

    refresh query_table.
    query_table-name  = '_OBJECT_ID'.                "#EC NOTEXT
    query_table-value = 'SAPSMARTFORMS'.             "#EC NOTEXT
    append query_table.

    call function 'WWW_GET_MIME_OBJECT'
         tables
              query_string        = query_table
              html                = html_table
              mime                = pic_data
         changing
              return_code         = return_code
              content_type        = content_type
              content_length      = content_length
         exceptions
              object_not_found    = 1
              parameter_not_found = 2
              others              = 3.
    if sy-subrc = 0.
      pic_size = content_length.
    endif.

    call function 'DP_CREATE_URL'
         exporting
              type     = 'image'
              subtype  = cndp_sap_tab_unknown
              size     = pic_size
              lifetime = cndp_lifetime_transaction
         tables
              data     = pic_data
         changing
              url      = url
         exceptions
              others   = 1.

    call method logo->load_picture_from_url
         exporting url     = url
         exceptions others = 1.

  endif.

endform.                    " init_picture_control

*&---------------------------------------------------------------------*
*&      Form  display_homepage
*&---------------------------------------------------------------------*
form display_homepage.

data: partner_flag like trpari-s_checked.

call function 'TR_GET_PARTNER_PROJECTS'
     importing  we_partner_flag = partner_flag
     exceptions others          = 1.
  if sy-subrc ne 0 or partner_flag eq false.
    screen_invisible 'SF_HOMEPAGE'.
  endif.

endform.                    " display_homepage