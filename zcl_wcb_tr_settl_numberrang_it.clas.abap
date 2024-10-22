class zcl_wcb_tr_settl_numberrang_it definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_tr_source_value_class .
  protected section.
  private section.

    class-data ss_proc_var_b type wcb_c_proc_var_b .
endclass.



class zcl_wcb_tr_settl_numberrang_it implementation.


  method if_wlf_tr_source_value_class~get_source_value.

    field-symbols <komk> type komk.
    field-symbols <komlfk> type komlfk.
    field-symbols <komlfp> type komlfp.
    field-symbols <wlf_s_number_assignement> type wlf_s_number_assignement.

    data ld_zone type zzona.


* get doc header and item
    read table it_source_copy_data assigning field-symbol(<it_source_copy_data>)
    with key structure = 'KOMLFK'.
    if sy-subrc = 0.
      assign <it_source_copy_data>-reference->* to <komlfk>.
    else.
      message x186(wab) with 'KOMLFK' i_tmtr-source_val_class i_tmtr-transfer_event i_tmtr-transfer_group.
    endif.

    read table it_target_copy_data assigning field-symbol(<it_target_copy_data>)
    with key structure = 'WLF_S_NUMBER_ASSIGNEMENT'.
    if sy-subrc = 0.
      assign <it_target_copy_data>-reference->* to <wlf_s_number_assignement>.
    else.
      message x185(wab) with 'wlf_s_number_assignement' i_tmtr-source_val_class i_tmtr-transfer_event i_tmtr-transfer_group.
    endif.



    create data rr_source_value type wbeln_ag.
    assign rr_source_value->* to field-symbol(<rr_source_value>).


    check <komlfk> is assigned.
    check <wlf_s_number_assignement> is assigned.
    check  ( <komlfk>-lfart = 'ZS12' or <komlfk>-lfart = '0S14' )
    and <komlfk>-bukrs = '1401'
    and <wlf_s_number_assignement>-numki is not initial.



      try.
          call function 'NUMBER_GET_NEXT'
            exporting
              nr_range_nr             = <wlf_s_number_assignement>-numki
              object                  = 'RV_BELEG'
              quantity                = '1'
*             subobject               = space
*             toyear                  = '0000'
              ignore_buffer           = 'S'
            importing
              number                  = <rr_source_value>
*             quantity                =
*             returncode              =
            exceptions
              interval_not_found      = 1
              number_range_not_intern = 2
              object_not_found        = 3
              quantity_is_0           = 4
              quantity_is_not_1       = 5
              interval_overflow       = 6
              buffer_overflow         = 7
              others                  = 8.
          if sy-subrc <> 0.
            message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          endif.
        catch cx_wb2_rebates.
      endtry.


    "Si estamos en el proceso de liquidación y no encotramos rango de numero
    "devolvemos error de cancelación.
    if <rr_source_value> is initial.
      message a001(zrappel).
    endif.

  endmethod.
endclass.
