*&---------------------------------------------------------------------*
*&  Include           RWB2R_DISPLAY_AB_DOCUMENTSTOP
*&---------------------------------------------------------------------*
*--- global data:
 tables:
   wcocoh,
   wcocoi,
   crm_jest,
   wbrk,
   wbrf.
 data gt_komlfk type komlfk_itab.
 data gt_komlfp type komlfp_itab.
 data gv_refresh type xfeld.
 data g_layout  type slis_layout_alv.
 data g_fieldcat type slis_t_fieldcat_alv.
* Lieferantenfakturatypem
 data: begin of lftyp,
         rechn type tmfk-lftyp value '01',   "Gechnung
         rechs type tmfk-lftyp value '02',   "Rechnungsstorno
         gut   type tmfk-lftyp value '03',   "Gutschrift
         guts  type tmfk-lftyp value '04',   "Gutschriftstorno
         rechl type tmfk-lftyp value '05',
         gutl  type tmfk-lftyp value '06',
       end of lftyp.
