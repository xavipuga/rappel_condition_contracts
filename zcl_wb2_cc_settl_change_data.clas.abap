class ZCL_WB2_CC_SETTL_CHANGE_DATA definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_WB2_CC_SETTL_CHANGE_DATA .
protected section.
private section.
ENDCLASS.



CLASS ZCL_WB2_CC_SETTL_CHANGE_DATA IMPLEMENTATION.


  method IF_WB2_CC_SETTL_CHANGE_DATA~CHANGE_DATA.
    check sy-uname = 'XPUGA'.

**    field-symbols <lt_data> type any table.
**    field-symbols <ld_matnr> type any.
**    field-symbols <ls_data> type any.
**
**    assign (CR_BVB_TAB_DATA->*) to <lt_data>.
**
**    loop at <lt_data> into <ls_data>.
***      assign component 'MATNR' of structure <ls_Data> to <ld_matnr>.
***       if <ld_matnr> <> '2017035'.
***         delete <ls_data>.
***       endif.
**    endloop.



  endmethod.
ENDCLASS.
