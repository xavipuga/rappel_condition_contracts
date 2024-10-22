class ZCX_ITALY_WRONG_INVOICE_DATE definition
  public
  inheriting from zcx_return
  final
  create public .

  public section.

    interfaces if_t100_message .

    methods constructor
      importing
        !textid    like if_t100_message=>t100key optional
        !previous  like previous optional
        !gt_return type bapiret2_t optional
        !msgty     type symsgty optional .
  protected section.
  private section.
ENDCLASS.



CLASS ZCX_ITALY_WRONG_INVOICE_DATE IMPLEMENTATION.


  method constructor ##ADT_SUPPRESS_GENERATION.
    call method super->constructor
      exporting
        previous  = previous
        gt_return = gt_return
        msgty     = msgty.
    clear me->textid.
    if textid is initial.
      if_t100_message~t100key = if_t100_message=>default_textid.
    else.
      if_t100_message~t100key = textid.
    endif.
  endmethod.
ENDCLASS.
