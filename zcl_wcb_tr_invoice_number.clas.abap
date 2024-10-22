class zcl_wcb_tr_invoice_number definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_tr_source_value_class .
  protected section.
  private section.

    class-data ss_proc_var_b type wcb_c_proc_var_b .
ENDCLASS.



CLASS ZCL_WCB_TR_INVOICE_NUMBER IMPLEMENTATION.


  method if_wlf_tr_source_value_class~get_source_value.
* Source value class for transfer manager
* it can be used in Events 23 and 23 to replace the tax indicator material with the indicator assigned to the process variant on company code level

* local data
*    field-symbols <komk> type komk.
*    field-symbols <komlfk> type komlfk.
    field-symbols <komlfp> type komlfp.

* get doc header and item
*    read table it_source_copy_data assigning field-symbol(<it_source_copy_data>)
*    with key structure = 'KOMLFK'.
*    if sy-subrc = 0.
*      assign <it_source_copy_data>-reference->* to <komlfk>.
*    else.
*      message x186(wab) with 'KOMLFK' i_tmtr-source_val_class i_tmtr-transfer_event i_tmtr-transfer_group.
*    endif.
    read table it_source_copy_data assigning field-symbol(<it_source_copy_data>)
    with key structure = 'KOMLFP'.
    if sy-subrc = 0.
      assign <it_source_copy_data>-reference->* to <komlfp>.
    endif.

    check <komlfp> is assigned.

** get pricing data
*    read table it_source_copy_data assigning <it_source_copy_data>
*    with key structure = 'KOMK'.
*    if sy-subrc = 0.
*      assign <it_source_copy_data>-reference->* to <komk>.
*    else.
*      message x186(wab) with 'KOMK' i_tmtr-source_val_class i_tmtr-transfer_event i_tmtr-transfer_group.
*    endif.
* create data
    create data rr_source_value type rkeg_ww005. "wlf_ref_doc_number.
    assign rr_source_value->* to field-symbol(<rr_source_value>).
* read data
    try.
*        if <komlfk>-deviating_settl_item is initial
*        and not ( <komlfk>-process_variant is initial
*                  and ( <komlfk>-wdtyp = cl_wzre_con=>wdtyp-cs
*                        or <komlfk>-wdtyp = cl_wzre_con=>wdtyp-vs
*                        or <komlfk>-is_collection is not initial ) ).
*          cl_wb2_ccs_services=>read_process_variant_bukrs(
*            exporting
*              i_process_variant = <komlfk>-process_variant
*              i_bukrs           = <komk>-bukrs
*            changing
*              cs_proc_var_b     = ss_proc_var_b ).
*        else.
*          cl_wb2_ccs_services=>read_process_variant_bukrs(
*            exporting
*              i_process_variant = <komlfp>-process_variant_i
*              i_bukrs           = <komk>-bukrs
*            changing
*              cs_proc_var_b     = ss_proc_var_b ).
*        endif.
* export
          <rr_source_value> = <komlfp>-wbelnv.
* no error
      catch cx_wb2_rebates.
    endtry.
  endmethod.
ENDCLASS.
