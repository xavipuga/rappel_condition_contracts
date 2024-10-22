*&---------------------------------------------------------------------*
*&  Include           RWB2R_DISPLAY_AB_DOCUMENTSE01
*&---------------------------------------------------------------------*
*-----------------------------------------------------------------------
* INITIALIZATION
*-----------------------------------------------------------------------
initialization.
  clear s_maxl.
  s_abflow = 'X'.
  s_onlyhd = 'X'.

at selection-screen output.
  perform hide_selection_fields.
*-----------------------------------------------------------------------
* AT SELECTION-SCREEN
*-----------------------------------------------------------------------
at selection-screen.


at selection-screen on value-request for s_disvar.
  perform alv_layout_f4 changing s_disvar.

*-----------------------------------------------------------------------
* START-OF-SELECTION
*-----------------------------------------------------------------------
start-of-selection.

  get wcocoh.

  get wbrk.
  append wbrk to gt_komlfk.

end-of-selection.


* call list output
  perform call_list_output.
