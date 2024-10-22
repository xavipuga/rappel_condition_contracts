class zcl_wcb_tr_invoice_kunag definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_tr_source_value_class .
  protected section.
  private section.

    class-data ss_proc_var_b type wcb_c_proc_var_b .
endclass.



class zcl_wcb_tr_invoice_kunag implementation.


  method if_wlf_tr_source_value_class~get_source_value.


* local data
    field-symbols <komlfp> type komlfp.

    read table it_source_copy_data assigning field-symbol(<it_source_copy_data>)
    with key structure = 'KOMLFP'.
    if sy-subrc = 0.
      assign <it_source_copy_data>-reference->* to <komlfp>.
    endif.

    check <komlfp> is assigned.

    create data rr_source_value type kunag. "wlf_ref_doc_number.
    assign rr_source_value->* to field-symbol(<rr_source_value>).
* read data
    try.
        select kunag into @data(ld_kunag)
        from vbrk up to 1 rows
        where vbeln = @<komlfp>-wbelnv.
        endselect.
        <rr_source_value> = ld_kunag.
      catch cx_wb2_rebates.
    endtry.
  endmethod.
endclass.
