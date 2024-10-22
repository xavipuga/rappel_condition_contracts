class zcl_wlf_italy_check_dates definition
  public
  final
  create public .

  public section.

    interfaces if_wlf_cm_check .
    interfaces if_wlf_cm_check_header_data .
  protected section.
  private section.
endclass.



class zcl_wlf_italy_check_dates implementation.


  method if_wlf_cm_check_header_data~check.

    check i_komlfk-lfart = 'ZS12' and
          i_komlfk-vkorg = '1401'.

    try.
        zcl_italy_check_dates=>check_italy_dates(
          i_invoice_date = i_komlfk-wfdat
          i_bukrs        = i_komlfk-vkorg
        ).

      catch zcx_italy_wrong_invoice_date into data(lo_exc).
        data(ls_msg) = lo_exc->get_bapiret2_struc( ).
        data(ls_msg_out) = value wzre_message(
          msgid = ls_msg-id
          msgty = ls_msg-type
          msgno = ls_msg-number
          msgv1 = ls_msg-message_v1
          msgv2 = ls_msg-message_v2
          msgv3 = ls_msg-message_v3
          msgv4 = ls_msg-message_v4
      ).



        data(lo_exc_out) = new cx_wlf_check_manager_error(
*      textid            =
*      previous          =
          a_message = ls_msg_out
*         a_wbeln   =
*         a_posnr   =
          a_msgty   = 'E'
*         a_process_type    =
*         a_fieldname       =
*         a_tabname =
*         a_error_object    =
*         a_add_partner_key =
*         a_add_prcdelm_key =
*         a_rap     =
*         a_add_text_key    =
*         at_messages       =
          a_cancel  = 'X'
        ).

        raise exception lo_exc_out.
    endtry.
  endmethod.


  method if_wlf_cm_check~refresh.
  endmethod.
endclass.
