*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZRAPPEL_FI_RR...................................*
DATA:  BEGIN OF STATUS_ZRAPPEL_FI_RR                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZRAPPEL_FI_RR                 .
CONTROLS: TCTRL_ZRAPPEL_FI_RR
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZRAPPEL_NR......................................*
DATA:  BEGIN OF STATUS_ZRAPPEL_NR                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZRAPPEL_NR                    .
CONTROLS: TCTRL_ZRAPPEL_NR
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZRAPPEL_FI_RR                 .
TABLES: *ZRAPPEL_NR                    .
TABLES: ZRAPPEL_FI_RR                  .
TABLES: ZRAPPEL_NR                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
