*&---------------------------------------------------------------------*
*&  Include           RWB2R_DISPLAY_AB_DOCUMENTSF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  ALV_LAYOUT_F4
*&---------------------------------------------------------------------*
*       Value help for ALV-Layout
*----------------------------------------------------------------------*
form alv_layout_f4  changing p_disvar type slis_vari.
* local data
  data l_variant type disvariant.
  data l_listtype type wlf_list_output_type.
* set listtype
  if s_head = 'X'.
    l_listtype = ' '.
  elseif s_hdit = 'X'.
    l_listtype = '2'.
  else.
    exit.
  endif.
* set parameters
  call function 'WLF_REPID_LIST_OUTPUT'
    exporting
      i_wdtyp          = cl_wzre_con=>wdtyp-sr
      i_listtype       = l_listtype
    importing
      e_repid          = l_variant-report
      e_variant_handle = l_variant-handle.
  l_variant-username = sy-uname.
* get variant data
  call function 'REUSE_ALV_VARIANT_F4'
    exporting
      is_variant = l_variant
      i_save     = 'A'
    importing
      es_variant = l_variant
    exceptions
      others     = 1.
  if sy-subrc = 0.
    p_disvar = l_variant-variant.
  endif.

endform.                    " ALV_LAYOUT_F4
*&---------------------------------------------------------------------*
*&      Form  CALL_LIST_OUTPUT
*&---------------------------------------------------------------------*
*       call list output depending on type
*----------------------------------------------------------------------*
form call_list_output .
  data l_variant type disvariant.
  field-symbols <ls_komlfp> type komlfp.
* dpp
  data l_xblck       type cvp_xblck.
  data l_auth_master type cvp_auth_master.
  data l_bukrs       type bukrs.
  field-symbols : <ls_wlfk> type line of komlfk_itab.
* do again until no refresh
  do.
*  DPP
    if cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) is not initial.
      loop at gt_komlfk assigning <ls_wlfk>.
        if <ls_wlfk>-bukrs_deb is not initial.
          l_bukrs = <ls_wlfk>-bukrs_deb.
        else.
          l_bukrs = <ls_wlfk>-bukrs.
        endif.
        if <ls_wlfk>-kunre is not initial.

          cl_wb2_dpp_read=>is_block_cust( exporting iv_kunnr       = <ls_wlfk>-kunre
                                                    iv_bukrs       = l_bukrs
                                          importing ev_xblck       = l_xblck
                                                    ev_auth_master = l_auth_master ).
          if l_xblck is not initial and l_auth_master is initial.
            delete gt_komlfk .
            continue.
          endif.
        endif.
        if <ls_wlfk>-kunrg is not initial.
          cl_wb2_dpp_read=>is_block_cust( exporting iv_kunnr       = <ls_wlfk>-kunrg
                                                    iv_bukrs       = l_bukrs
                                          importing ev_xblck       = l_xblck
                                                    ev_auth_master = l_auth_master ).
          if l_xblck is not initial and l_auth_master is initial.
            delete gt_komlfk .
            continue.
          endif.
        endif.
        if <ls_wlfk>-lnrzb is not initial.
          cl_wb2_dpp_read=>is_block_vend( exporting iv_lifnr       = <ls_wlfk>-lnrzb
                                                    iv_bukrs       = <ls_wlfk>-bukrs
                                          importing ev_xblck       = l_xblck
                                                    ev_auth_master = l_auth_master ).
          if l_xblck is not initial and l_auth_master is initial.
            delete gt_komlfk .
            continue.
          endif.
        endif.
        if <ls_wlfk>-lifre is not initial.
          cl_wb2_dpp_read=>is_block_vend( exporting iv_lifnr       = <ls_wlfk>-lifre
                                                    iv_bukrs       = <ls_wlfk>-bukrs
                                          importing ev_xblck       = l_xblck
                                                    ev_auth_master = l_auth_master ).
          if l_xblck is not initial and l_auth_master is initial.
            delete gt_komlfk .
          endif.
        endif.
      endloop.
    endif.
* Falls keine Belege gefunden
    if gt_komlfk[] is initial.
      message i071(ws).
    else.
      describe table gt_komlfk.
      if s_max_ab = sy-tfill.
        message s207(cl) with sy-tfill.
      else.
        message s057(wb2r) with sy-tfill.
      endif.
    endif.

* Cambiamos los signos de los importes en el caso de los documentos de liquidación y anulación
    loop at gt_komlfk into data(ls_komlfk).
      if ls_komlfk-lfart = 'ZS12' or
         ls_komlfk-lfart = '0S14'.

        ls_komlfk-netwr = ls_komlfk-netwr * ( -1 ).
        ls_komlfk-mwsbk = ls_komlfk-mwsbk * ( -1 ).
        ls_komlfk-brtwr = ls_komlfk-brtwr * ( -1 ).
        ls_komlfk-netwrd = ls_komlfk-netwrd * ( -1 ).
        ls_komlfk-mwsbkd = ls_komlfk-mwsbkd * ( -1 ).
        ls_komlfk-brtwrd = ls_komlfk-brtwrd * ( -1 ).
        modify gt_komlfk from ls_komlfk.

      endif.
    endloop.

* output
    if s_head = 'X'.
* adjust sign if requested
      if not s_sign is initial.
        perform change_sign_komlfk tables gt_komlfk
                                    using s_sign.
      endif.
* Ausgabe
      call function 'WLF_PRINT_REGU_LIST'
        exporting
          i_report          = 'RWLF1005'
          i_mode            = s_mode
          i_variant         = s_disvar
          i_fieldcat        = g_fieldcat
          i_authority_check = abap_false
        tables
          t_komlfk          = gt_komlfk
        exceptions
          others            = 0.
    else.
      if not gt_komlfk is initial.
        select * from wbrp into table gt_komlfp
          for all entries in gt_komlfk
          where wbeln = gt_komlfk-wbeln
          order by primary key.
*--- STED Migration
        if sy-subrc = 0.
          loop at gt_komlfp assigning <ls_komlfp> where ( ref_doc_nr_1 is not initial
                                                          or ref_doc_nr_2 is not initial ).
            cl_wlf_tables_migration_util=>adjust_komlfp_wbrp_aft_reading(
              changing
                cs_komlfp = <ls_komlfp> ).
          endloop.
        endif.
      endif.
* adjust sign if requested
      if not s_sign is initial.
        perform change_sign_komlfp_komlfk tables gt_komlfk gt_komlfp
                                           using s_sign.
      endif.
      call function 'WLF_PRINT_REGU_LIST_HI'
        exporting
          i_report          = 'RWLF1051'
          it_komlfk         = gt_komlfk
          it_komlfp         = gt_komlfp
          i_mode            = s_mode
          i_variant         = s_disvar
          i_fieldcat        = g_fieldcat
          i_authority_check = abap_false
        exceptions
          others            = 0.
    endif.
* exit if no refresh
    call function 'WLF_PRINT_REFRESH_GET'
      importing
        e_refresh  = gv_refresh
        e_fieldcat = g_fieldcat
        e_variant  = l_variant.
    if gv_refresh is initial.
      exit.
    else.
      if l_variant-variant is not initial.
        s_disvar = l_variant-variant.
      endif.
      perform refresh.
    endif.
  enddo.
endform.                    " CALL_LIST_OUTPUT

form change_sign_komlfk tables ct_komlfk structure komlfk
                         using s_sign    type c.
  call function 'WLF_ADJUST_SIGN_LIST_OUTPUT'
    exporting
      i_adjust_sign = s_sign
    changing
      ct_komlfk     = ct_komlfk[].
endform.
form change_sign_komlfp_komlfk tables ct_komlfk structure komlfk
                                      ct_komlfp structure komlfp
                                using s_sign    type c.
* via FM
  call function 'WLF_ADJUST_SIGN_LIST_OUTPUT'
    exporting
      i_adjust_sign = s_sign
    changing
      ct_komlfk     = ct_komlfk[]
      ct_komlfp     = ct_komlfp[].
endform.

*&---------------------------------------------------------------------*
*&      Form  refresh
*&---------------------------------------------------------------------*
*       Refresh data via new seleciton from ldb
*----------------------------------------------------------------------*
form refresh.

  data lt_rsparams type table of rsparams.
  data lty_trange type rsds_trange.
  data lty_texpr type rsds_texpr.
  data lt_callback type table of ldbcb.
  data ls_callback like line of lt_callback.

* init
  clear gt_komlfk.
  clear gt_komlfp.

* get selections
  call function 'RS_REFRESH_FROM_SELECTOPTIONS'
    exporting
      curr_report     = sy-repid
    tables
      selection_table = lt_rsparams
    exceptions
      not_found       = 1
      no_report       = 2
      others          = 3.
  check sy-subrc = 0.
* get free selections
  call function 'RS_REFRESH_FROM_DYNAMICAL_SEL'
    exporting
      curr_report        = sy-repid
      mode_write_or_move = 'M'
    importing
      p_trange           = lty_trange
    exceptions
      not_found          = 1
      wrong_type         = 2
      others             = 3.
  if sy-subrc is initial.
    call function 'FREE_SELECTIONS_RANGE_2_EX'
      exporting
        field_ranges = lty_trange
      importing
        expressions  = lty_texpr.
  endif.

* set callback routines
  ls_callback-ldbnode = 'WCOCOH'.
  ls_callback-get = 'X'.
  ls_callback-cb_prog = sy-repid.
  ls_callback-cb_form = 'REFRESH_SET_DATA'.
  append ls_callback to lt_callback.
  ls_callback-ldbnode = 'WBRK'.
  append ls_callback to lt_callback.

* process ldb
  call function 'LDB_PROCESS'
    exporting
      ldbname     = sy-dbnam
      expressions = lty_texpr
    tables
      callback    = lt_callback
      selections  = lt_rsparams
    exceptions
      others      = 0.

endform.                    "refresh
*&---------------------------------------------------------------------*
*&      Form  REFRESH_SET_DATA
*&---------------------------------------------------------------------*
*       receive new selection data from ldb
*----------------------------------------------------------------------*
form refresh_set_data using name like ldbn-ldbnode  " Name des Knotens
                          workarea                " Daten
                           mode     type c         " G(et) oder L(ate)
                           selected type c.        " Knoten gewünscht?

  case name.
    when 'WCOCOH'.

    when 'WBRK'.
      append workarea to gt_komlfk.
  endcase.

endform.                    "REFRESH_SET_DATA


form hide_selection_fields.
  loop at screen.
    if screen-group1 = 'CES' or screen-group1 = 'CE'.
      if cl_wlf_switch_check=>ms_is_s4hc_cloud_on = abap_true.
        screen-invisible = 1.
        screen-input = 0.
        screen-active = 0.
        modify screen.
        continue.
      endif.
    endif.
    if screen-group1 = 'CPV'.
      if cl_wlf_switch_check=>ms_is_s4hc_cloud_on = abap_true.
        screen-invisible = 1.
        screen-input = 0.
        screen-output = 0.
        screen-active = 0.
        modify screen.
        continue.
      endif.
    endif.
    if screen-group1 = 'COS' or screen-group1 = 'CSP'.
      if cl_wlf_switch_check=>ms_is_s4hc_cloud_on = abap_true  and
        cl_wcb_det_cctype_attributes=>is_purch_rebate_available( ) = abap_false.
        screen-invisible = 1.
        screen-input = 0.
        screen-output = 0.
        screen-active = 0.
        modify screen.
        continue.
      endif.
    endif.
    if screen-group1 = 'CCU'.
      if cl_wlf_switch_check=>ms_is_s4hc_cloud_on = abap_true and
        cl_wcb_det_cctype_attributes=>is_sales_rebate_available( ) = abap_false.
        screen-invisible = 1.
        screen-input = 0.
        screen-output = 0.
        screen-active = 0.
        modify screen.
        continue.
      endif.
    endif.
  endloop.
endform.
