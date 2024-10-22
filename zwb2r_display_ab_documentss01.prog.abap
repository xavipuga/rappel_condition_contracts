*&---------------------------------------------------------------------*
*&  Include           RWB2R_DISPLAY_AB_DOCUMENTSS01
*&---------------------------------------------------------------------*
* AB documents
selection-screen begin of block docs with frame title text-s07.
  select-options s_rfbsk for wbrk-rfbsk.
  select-options s_wrart for wbrk-wrart.
  select-options s_lfart for wbrk-lfart.
  select-options s_wfdat for wbrk-wfdat.
  select-options s_ernam for wbrk-ernam.
  select-options s_erdat for wbrk-erdat.
  select-options s_ucase for wbrk-use_case matchcode object wlf_sh_ccs_use_case.
  select-options s_estat for wbrk-estatus.
selection-screen end of block docs.
* output
selection-screen begin of block ausgabe with frame title text-s06.
  parameters s_head type xfeld radiobutton group r1 default 'X'.
  parameters s_hdit type xfeld radiobutton group r1.
  parameters s_mode type wlf_list_mode as listbox visible length 50.
  parameters s_sign type wb2_adjust_sign as listbox visible length 50 default 'D' memory id wlf_adjust_sign ##EXISTS.
  parameters s_disvar like disvariant-variant.
selection-screen end of block ausgabe.
