class zcl_wcb_tr_settl_number_range definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_tr_source_value_class .
  protected section.
  private section.

    class-data ss_proc_var_b type wcb_c_proc_var_b .
endclass.



class zcl_wcb_tr_settl_number_range implementation.


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
             <komlfk>-bukrs <> '1401'.

    "Dependiendo de la sociedad y el tipo de documento de liquidación asignamos un rango de nº
    check <komlfk>-contract is not initial.
    select * from wcocoh into @data(ls_wcocoh)
    up to 1 rows
    where num = @<komlfk>-contract.
    endselect.
    check sy-subrc = 0.

    "Seleccionem el pais del beneficiari del rappel
    select land1 from kna1 into @data(ld_kunnr_land1)
    up to 1 rows
    where kunnr = @ls_wcocoh-cust_owner.
    endselect.
    if sy-subrc = 0.
      "Seleccionem el pais de la societat
      select land1 from t001 into @data(ld_bukrs_land1)
      up to 1 rows
      where bukrs = @<komlfk>-bukrs.
      endselect.

      if sy-subrc = 0.
        if ld_kunnr_land1 = ld_bukrs_land1. "Nacional.
          ld_zone = 'NAC'.

        else.
          select xegld into @data(ld_cee)
          from t005 up to 1 rows
          where land1 = @ld_kunnr_land1.
          endselect.
          if sy-subrc = 0.
            if ld_cee is initial.
              ld_zone = 'EXP'.
            else.
              ld_zone = 'CEE'.
            endif.
          endif.
        endif.
      endif.
    endif.

    if ld_zone is not initial and <komlfk>-lfart is not initial.
      select * from zrappel_nr into @data(ls_nr)
      up to 1 rows
      where bukrs = @<komlfk>-bukrs
      and   lfart = @<komlfk>-lfart
      and   zzona = @ld_zone.
      endselect.
      if sy-subrc = 0 and ls_nr-nrrangenr is not initial.
        try.
            <rr_source_value> = ls_nr-nrrangenr.
          catch cx_wb2_rebates.
        endtry.
      endif.
    endif.

    "Si estamos en el proceso de liquidación y no encotramos rango de numero
    "devolvemos error de cancelación.
    if  <rr_source_value> is initial.
      message a001(zrappel).
    endif.

  endmethod.
endclass.
