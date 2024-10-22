class zcl_wcb_tr_invoice_salesitem definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_tr_source_value_class .
  protected section.
  private section.

    class-data ss_proc_var_b type wcb_c_proc_var_b .
endclass.



class zcl_wcb_tr_invoice_salesitem implementation.


  method if_wlf_tr_source_value_class~get_source_value.


* local data
    field-symbols <komlfp> type komlfp.

    read table it_source_copy_data assigning field-symbol(<it_source_copy_data>)
    with key structure = 'KOMLFP'.
    if sy-subrc = 0.
      assign <it_source_copy_data>-reference->* to <komlfp>.
    endif.

    check <komlfp> is assigned.

    create data rr_source_value type posnr_va.
    assign rr_source_value->* to field-symbol(<rr_source_value>).
* read data

    try.
        select * into @data(ls_vbrp)
        from vbrp
        up to 1 rows
        where vbeln = @<komlfp>-wbelnv
        and   posnr = @<komlfp>-posnrv.
        endselect.
        if sy-subrc = 0.
          <rr_source_value> = ls_vbrp-aupos.
        endif.
      catch cx_wb2_rebates.
    endtry.
  endmethod.
endclass.
