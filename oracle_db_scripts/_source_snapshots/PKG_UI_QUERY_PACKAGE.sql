PACKAGE "PKG_UI_QUERY" is

  -- Author  : ZETHANI
  -- Created : 2015-05-20 ???? 10:50:51
  -- Purpose : Ui ??ackage
  TYPE T_LOSS_RATE_R IS RECORD( LINE_CODE    VARCHAR2(20),
                                RATE_M1       NUMBER,
                                VAL_M1       NUMBER,
                                RATE_M2       NUMBER,
                                VAL_M2       NUMBER,
                                RATE_M3       NUMBER,
                                VAL_M3       NUMBER,
                                RATE_M4       NUMBER,
                                VAL_M4       NUMBER,
                                RATE_M5       NUMBER,
                                VAL_M5       NUMBER,
                                RATE_M6       NUMBER,
                                VAL_M6       NUMBER,
                                RATE_TTL     NUMBER,
                                VAL_TTL      NUMBER
                               );

  TYPE T_LOSS_RATE_T IS TABLE OF T_LOSS_RATE_R ;

  FUNCTION FN_LOSS_RATE RETURN T_LOSS_RATE_T PIPELINED;


end PKG_UI_QUERY;