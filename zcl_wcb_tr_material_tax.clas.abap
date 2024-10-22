class zcl_wcb_tr_material_tax definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_tr_source_value_class .
  protected section.
  private section.

    class-data ss_proc_var_b type wcb_c_proc_var_b .
ENDCLASS.



CLASS ZCL_WCB_TR_MATERIAL_TAX IMPLEMENTATION.


  method if_wlf_tr_source_value_class~get_source_value.

    field-symbols <komk> type komk.
    field-symbols <komlfk> type komlfk.
    field-symbols <komlfp> type komlfp.



* get doc header and item
    read table it_source_copy_data assigning field-symbol(<it_source_copy_data>)
    with key structure = 'KOMLFK'.
    if sy-subrc = 0.
      assign <it_source_copy_data>-reference->* to <komlfk>.
    else.
      message x186(wab) with 'KOMLFK' i_tmtr-source_val_class i_tmtr-transfer_event i_tmtr-transfer_group.
    endif.
    read table it_source_copy_data assigning <it_source_copy_data>
    with key structure = 'KOMLFP'.
    if sy-subrc = 0.
      assign <it_source_copy_data>-reference->* to <komlfp>.
    endif.
* get pricing data
    read table it_source_copy_data assigning <it_source_copy_data>
    with key structure = 'KOMK'.
    if sy-subrc = 0.
      assign <it_source_copy_data>-reference->* to <komk>.
    else.
      message x186(wab) with 'KOMK' i_tmtr-source_val_class i_tmtr-transfer_event i_tmtr-transfer_group.
    endif.

    create data rr_source_value type wlf_d_taxim.
    assign rr_source_value->* to field-symbol(<rr_source_value>).

    check <komlfk> is assigned.

    "Si tenbemos el contrato buscampos si está informado el material de liquidación.
    if <komlfk>-contract is not initial.
      select * from wcocoh into @data(ls_wcocoh)
      up to 1 rows
      where num = @<komlfk>-contract.
      endselect.
      if sy-subrc = 0 and ls_wcocoh-settl_matnr is not initial
        and ls_wcocoh-settl_matnr <> '000000000009000014'.
        select * from mlan into @data(ls_mlan)
        up to 1 rows
        where matnr = @ls_wcocoh-settl_matnr
        and   aland = @<komlfk>-land_bukrs.
        endselect.
        if sy-subrc = 0.
          try.
              <rr_source_value> = ls_mlan-taxm1.
            catch cx_wb2_rebates.
          endtry.
        endif.
      endif.
    endif.

  endmethod.
ENDCLASS.
