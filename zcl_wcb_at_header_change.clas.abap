class zcl_wcb_at_header_change definition
  public
  final
  create public .

  public section.

    interfaces if_badi_interface .
    interfaces if_wcb_at_header_change .
  protected section.
  private section.
endclass.



class zcl_wcb_at_header_change implementation.


  method if_wcb_at_header_change~at_change.
    if ch_komwcocoh-zterm is initial and
    ( ch_komwcocoh-vkorg is not initial and
      ch_komwcocoh-vtweg is not initial and
      ch_komwcocoh-spart is not initial ).

      select * from knvv into @data(ls_knvv)
      up to 1 rows
      where kunnr = @ch_komwcocoh-cust_owner
      and   vkorg = @ch_komwcocoh-vkorg
      and   vtweg = @ch_komwcocoh-vtweg
      and   spart = @ch_komwcocoh-spart.
      endselect.
      if sy-subrc = 0.
        ch_komwcocoh-zterm = ls_knvv-zterm.
      endif.

    endif.
  endmethod.


  method if_wcb_at_header_change~at_cal_change.
  endmethod.


  method if_wcb_at_header_change~fill_dynamic_head_data.
  endmethod.
endclass.
