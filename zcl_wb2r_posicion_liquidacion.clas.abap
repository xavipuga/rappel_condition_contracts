class ZCL_WB2R_POSICION_LIQUIDACION definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_WB2_CC_SETTL_CHANGE_ITEM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_WB2R_POSICION_LIQUIDACION IMPLEMENTATION.


  method IF_WB2_CC_SETTL_CHANGE_ITEM~CHANGE_ITEM_DATA.
     check 1 = 2.
  endmethod.
ENDCLASS.
