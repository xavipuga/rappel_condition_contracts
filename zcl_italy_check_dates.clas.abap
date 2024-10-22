class zcl_italy_check_dates definition
  public
  final
  create public .

  public section.
    class-methods check_italy_dates
      importing i_invoice_date type fkdat
                i_bukrs        type bukrs
      raising   zcx_italy_wrong_invoice_date.


  protected section.
  private section.
endclass.



class zcl_italy_check_dates implementation.
  method check_italy_dates.
    select * from zsddatafactura into @data(ls_data)
        up to 1 rows
        where bukrs = @i_bukrs.
    endselect.

    "Seleccionamos la fecha máxima de ventas
    select max( fkdat ) from vbrk into @data(ld_lastdate_sd)
    where bukrs = @i_bukrs.

    "Seleccionamos la fecha máxima de documentos de liquidación
    "Seleccionamos la fecha máxima de ventas
    select max( wfdat ) from wbrk into @data(ld_lastdate_rappel)
    where ( lfart = 'ZS12' or lfart = '0S14' )
    and   bukrs = @i_bukrs.

    if ld_lastdate_sd > ld_lastdate_rappel.
      data(ld_lastdate) = ld_lastdate_sd.

    elseif ld_lastdate_rappel > ld_lastdate_sd.
      ld_lastdate = ld_lastdate_rappel.

    else.
      ld_lastdate = ld_lastdate_sd.
    endif.

    "Comprobar fecha en ZSD042 y fecha última factura.
    if ls_data-datamaxima < ld_lastdate.
      message e602(zsd) into data(ld_message).
      data(lo_exc) = new zcx_italy_wrong_invoice_date( ).
      lo_exc->add_message(  ).
      raise exception lo_exc.

    elseif ls_data-datamaxima > sy-datum.
      message e600(zrappel) into ld_message.
      lo_exc = new zcx_italy_wrong_invoice_date( ).
      lo_exc->add_message(  ).
      raise exception lo_exc.

    endif.

    if i_invoice_date > sy-datum.
      message e600(zsd) into ld_message. " DISPLAY LIKE 'I'.
      lo_exc = new zcx_italy_wrong_invoice_date( ).
      lo_exc->add_message(  ).
      raise exception lo_exc.

    elseif i_invoice_date > ls_data-datamaxima.
      message e602(zsd) into ld_message. " DISPLAY LIKE 'I'.
      lo_exc = new zcx_italy_wrong_invoice_date( ).
      lo_exc->add_message(  ).
      raise exception lo_exc.
    elseif i_invoice_date >= ld_lastdate and i_invoice_date < ls_data-datamaxima.
* ok
    elseif i_invoice_date < ld_lastdate.
      message e601(zrappel) into ld_message. " DISPLAY LIKE 'I'.
      lo_exc = new zcx_italy_wrong_invoice_date( ).
      lo_exc->add_message(  ).
      raise exception lo_exc.
    endif.
  endmethod.

endclass.
