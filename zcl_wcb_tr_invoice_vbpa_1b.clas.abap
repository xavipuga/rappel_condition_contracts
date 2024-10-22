class zcl_wcb_tr_invoice_vbpa_1b definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_tr_source_value_class .
  protected section.
  private section.

    class-data ss_proc_var_b type wcb_c_proc_var_b .
endclass.



class zcl_wcb_tr_invoice_vbpa_1b implementation.


  method if_wlf_tr_source_value_class~get_source_value.


* local data
    field-symbols <komlfp> type komlfp.

    read table it_source_copy_data assigning field-symbol(<it_source_copy_data>)
    with key structure = 'KOMLFP'.
    if sy-subrc = 0.
      assign <it_source_copy_data>-reference->* to <komlfp>.
    endif.

    check <komlfp> is assigned.

    create data rr_source_value type hiezu01.
    assign rr_source_value->* to field-symbol(<rr_source_value>).
* read data

    try.
        select * into table @data(lt_vbpa)
        from vbpa
        where vbeln = @<komlfp>-wbelnv.

        read table lt_vbpa into data(ls_vbpa)
        with key posnr = <komlfp>-posnrv
                 parvw = '1B'.
        if sy-subrc <> 0.
          read table lt_vbpa into ls_vbpa
            with key posnr = '000000'
                 parvw = '1B'.
          if sy-subrc = 0.
            <rr_source_value> = ls_vbpa-kunnr.
          else.
            read table lt_vbpa into ls_vbpa
             with key posnr = '000010'
             parvw = '1B'.
            if sy-subrc = 0.
              <rr_source_value> = ls_vbpa-kunnr.
            endif.
          endif.
        else.
          <rr_source_value> = ls_vbpa-kunnr.
        endif.
      catch cx_wb2_rebates.
    endtry.
  endmethod.
endclass.
