class zcl_wb2_contract_defaults definition
  public
  final
  create public .

  public section.

    interfaces if_badi_interface .
    interfaces if_wcb_set_header_default_badi .
  protected section.
  private section.
endclass.



class zcl_wb2_contract_defaults implementation.


  method if_wcb_set_header_default_badi~set_default.



    "Añadimos por defecto a los contratos un material de liquidación
    " En el caso de no tener volumen de negocios se usará este material
    "para el documento de liquidación con valor 0
    ch_komwcocoh-settl_matnr = '000000000009000014'.

    data(ls_changed_field) = value wcb_changed_fields(
        tabname   = 'WCOCOH'
        fieldname = 'SETTL_MATNR'
        ).

    data(ld_index) = lines( t_changed_field ).
    ld_index = ld_index + 1.

    insert ls_changed_field into table t_changed_field.
    clear ld_index.
    clear ls_changed_field.

  endmethod.
endclass.
