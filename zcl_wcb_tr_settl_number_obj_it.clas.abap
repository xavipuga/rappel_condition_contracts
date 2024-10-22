class zcl_wcb_tr_settl_number_obj_it definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_tr_source_value_class .
  protected section.
  private section.

    class-data ss_proc_var_b type wcb_c_proc_var_b .
endclass.



class zcl_wcb_tr_settl_number_obj_it implementation.


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

    create data rr_source_value type numki.
    assign rr_source_value->* to field-symbol(<rr_source_value>).


    check <komlfk> is assigned.

    check  ( <komlfk>-lfart = 'ZS12' or <komlfk>-lfart = '0S14' ) and
             <komlfk>-bukrs = '1401'.


    select * from zsd003_any into @data(ls_zsd003_any)
      up to 1 rows
      where zcomp = @<komlfk>-bukrs
      and any_factura = @<komlfk>-wfdat(4).
    endselect.
    if sy-subrc = 0.
      <rr_source_value> = ls_zsd003_any-zrang.
    endif.

    "Si estamos en el proceso de liquidación y no encotramos rango de numero
    "devolvemos error de cancelación.
    if  <rr_source_value> is initial.
      message a001(zrappel).
    endif.

  endmethod.
endclass.
