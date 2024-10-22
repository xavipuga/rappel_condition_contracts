*&---------------------------------------------------------------------*
*& Report  RWB2R_DISPLAY_AB_DOCUMENTS
*&
*&---------------------------------------------------------------------*
*& Display of Agency Business documents for Condition Contracts
*& Selection via Document Flow
*&---------------------------------------------------------------------*

report  zwb2r_display_documents.
*--- global data:
INCLUDE ZWB2R_DISPLAY_AB_DOCUMENTSTOP.
*include rwb2r_display_ab_documentstop.

*--- selection screen:
INCLUDE ZWB2R_DISPLAY_AB_DOCUMENTSS01.
*include rwb2r_display_ab_documentss01.

*--- events:
INCLUDE ZWB2R_DISPLAY_DOCUMENTSE01.
*include rwb2r_display_ab_documentse01.

*--- sub-routines:
INCLUDE ZWB2R_DISPLAY_AB_DOCUMENTSF01.
*include rwb2r_display_ab_documentsf01.
