class zcl_wcb_tr_settl_fi_doctyp definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_tr_source_value_class .
  protected section.
  private section.

    class-data ss_proc_var_b type wcb_c_proc_var_b .
endclass.


class zcl_wcb_tr_settl_fi_doctyp implementation.


  method if_wlf_tr_source_value_class~get_source_value.

    field-symbols <komk> type komk.
    field-symbols <komlfk> type komlfk.
    field-symbols <komlfp> type komlfp.

    data ld_zone type zzona.


* get doc header and item
    read table it_source_copy_data assigning field-symbol(<it_source_copy_data>)
    with key structure = 'KOMLFK'.
    if sy-subrc = 0.
      assign <it_source_copy_data>-reference->* to <komlfk>.
    else.
      message x186(wab) with 'KOMLFK' i_tmtr-source_val_class i_tmtr-transfer_event i_tmtr-transfer_group.
    endif.

    create data rr_source_value type blart.
    assign rr_source_value->* to field-symbol(<rr_source_value>).

    check <komlfk> is assigned.

    "Si el cliente está en la tabla ZRAPPEL_FI_RR cambiamos la clase de documento FI a RR
     if <komlfk>-contract is not initial.
       select * from wcocoh into @data(ls_wcocoh)
      up to 1 rows
      where num = @<komlfk>-contract.
      endselect.
      if sy-subrc = 0.
        select * from zrappel_fi_rr into @data(ls_rr)
        up to 1 rows
        where  vkorg = @ls_wcocoh-vkorg
        and    kunnr = @ls_wcocoh-cust_owner.
        endselect.
        if sy-subrc = 0.
            try.
                <rr_source_value> = 'RR'.
              catch cx_wb2_rebates.
            endtry.
*          endif.
        endif.
      endif.
    endif.

  endmethod.
endclass.
