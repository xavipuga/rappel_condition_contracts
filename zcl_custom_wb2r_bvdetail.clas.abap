class zcl_custom_wb2r_bvdetail definition
  public
  final
  create public .

  public section.

    interfaces if_badi_interface .
    interfaces if_wb2_ccs_bvdetail_output .
  protected section.
  private section.
endclass.



class zcl_custom_wb2r_bvdetail implementation.


  method if_wb2_ccs_bvdetail_output~change_before_output.

    sort ct_output by wbeln doc_id.

    loop at ct_output into data(ls_output).
      data(ld_index) = sy-tabix.

      read table it_komlfp into data(ls_komlfp)
      with key wbeln = ls_output-wbeln
               posnr = ls_output-posnr.
      if sy-subrc = 0.
        ls_output-netwr = ls_komlfp-netwr.
      endif.

      read table it_komlfk into data(ls_komlfk)
      with key wbeln = ls_output-wbeln.
      if sy-subrc = 0.
        ls_output-lfart = ls_komlfk-lfart.
      endif.

      select single * from vbrp into @data(ls_vbrp)
      where vbeln = @ls_output-doc_id
      and   posnr = @ls_output-doc_item.
      if sy-subrc = 0.
        ls_output-kunag_ana = ls_vbrp-kunag_ana.
        ls_output-kunrg_ana = ls_vbrp-kunrg_ana.
      endif.

      if ls_output-busvol_1 is not initial.
        ls_output-rappel = ( ls_output-netwr / ls_output-busvol_1 ) * 100.
      endif.
      modify ct_output from ls_output.

      if ls_output-netwr is initial.
        delete ct_output index ld_index.
      endif.

    endloop.
  endmethod.


  method if_wb2_ccs_bvdetail_output~handle_toolbar.
  endmethod.


  method if_wb2_ccs_bvdetail_output~handle_user_command.
  endmethod.
endclass.
