class zcl_wlf_acc_enhancement_ext definition
  public
  final
  create public .

  public section.

    interfaces if_badi_interface .
    interfaces if_wlf_acc_enhancement_ext .
  protected section.
  private section.
endclass.



class zcl_wlf_acc_enhancement_ext implementation.


  method if_wlf_acc_enhancement_ext~change_accrual_line.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_after_summarization.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_before_summarization.
    check sy-uname = 'XPUGA'.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_cancel_type.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_customer_line.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_customer_line_adv_paym.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_customer_line_cond.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_header_line.
    "Per l'autofactura es fa servir el camp referencia externa
    "del contracte per indicar la referencia d'autofactura del client
    "necessari pel SII
    "En cas d'estar ple ho passem al camp BKPF-BKTXT del document FI
    field-symbols <komlfk> type any.
    assign i_komlfk->* to <komlfk>.
    check sy-subrc = 0.

    assign component 'LFART' of structure <komlfk> to field-symbol(<lfart>).
    check sy-subrc = 0.
    check <lfart> = 'ZS12' or <lfart> = '0S14'.

    assign component 'CONTRACT' of structure <komlfk> to field-symbol(<contract>).
    check sy-subrc = 0 and <contract> is not initial.

    select ext_num from wcocoh into @data(ld_ext_num)
    up to 1 rows
    where num = @<contract>.
    endselect.
    if sy-subrc = 0 and ld_ext_num is not initial.
      assign c_acchd->* to field-symbol(<acchd>).
      check sy-subrc = 0.
      assign component 'BKTXT' of structure <acchd> to field-symbol(<bktxt>).
      check sy-subrc = 0.
      <bktxt> = ld_ext_num.
    endif.

  endmethod.


  method if_wlf_acc_enhancement_ext~change_item_line.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_item_line_remu_list.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_material_line.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_parameters.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_parameters_item.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_parameters_komv.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_parameters_list_item.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_posting_key.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_posting_string_values.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_post_via_pricing_vdb.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_revers_account_ref_info.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_tax_line.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_vendor_line.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_vendor_line_adv_paym.
  endmethod.


  method if_wlf_acc_enhancement_ext~change_vendor_line_cond.
  endmethod.
endclass.
