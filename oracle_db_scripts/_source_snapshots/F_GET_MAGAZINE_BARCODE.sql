FUNCTION "F_GET_MAGAZINE_BARCODE" (P_BOX_BARCODE IN VARCHAR2) RETURN VARCHAR2 IS

  LVS_MAGAZINE_BARCODE VARCHAR2(500);
  LVS_BARCODE_LENGTH   NUMBER;

  LVI_POS1             NUMBER;
  LVI_POS2             NUMBER;
  LVI_GAP              NUMBER;

BEGIN

  LVS_MAGAZINE_BARCODE := P_BOX_BARCODE;
  LVS_BARCODE_LENGTH   := 0;

  -- GET MAGAZINE NO

  IF SUBSTR(P_BOX_BARCODE,1,6) = '[)>@06' THEN

  ------------------------------------------------------------------------------------------------------------
  -- 2016/08/31 SHS, BOSCH ？？？？？？ART NUMBER ？？ ？？？？？？？？？？ o？？ ？
  -- "[)>@06@P1038408234BA@1P1038408234.005@1T20160830@2T8709@Q8@V5390507009@30PN@20PyyyyMMddHHmm@@"
  --                                          --------   ----
  ------------------------------------------------------------------------------------------------------------

           LVI_POS1  := INSTR (P_BOX_BARCODE, '@1T');
           LVI_POS2  := INSTR (P_BOX_BARCODE, '@2T', LVI_POS1+1);
           LVI_GAP   := LVI_POS2 - LVI_POS1;

           LVS_MAGAZINE_BARCODE := SUBSTR(P_BOX_BARCODE, LVI_POS1+3, LVI_GAP-3);

           LVI_POS1  := INSTR (P_BOX_BARCODE, '@2T');
           LVI_POS2  := INSTR (P_BOX_BARCODE, '@Q', LVI_POS1+1);
           LVI_GAP   := LVI_POS2 - LVI_POS1;

           LVS_MAGAZINE_BARCODE := LVS_MAGAZINE_BARCODE||SUBSTR(P_BOX_BARCODE, LVI_POS1+3, LVI_GAP-3);

  ELSIF SUBSTR(P_BOX_BARCODE, 1,6) = '[)>'||CHR(30)||'06' THEN

  ------------------------------------------------------------------------------------------------------------
  -- HYUNDAE KEFICO
  -- "[)>06VSNWPP9101200343Q2T20160817SB01627D20160817UEA"
  --                          --------   ----
  ------------------------------------------------------------------------------------------------------------

           lvi_pos1  := INSTR (P_BOX_BARCODE, CHR(29)||'T');
           lvi_pos2  := INSTR (P_BOX_BARCODE, CHR(29), lvi_pos1+1);
           lvi_gap   := lvi_pos2 - lvi_pos1;

           LVS_MAGAZINE_BARCODE := SUBSTR(P_BOX_BARCODE, lvi_pos1+2, lvi_gap-2);

           lvi_pos1  := INSTR (P_BOX_BARCODE, CHR(29)||'SB');
           lvi_pos2  := INSTR (P_BOX_BARCODE, CHR(29), lvi_pos1+1);
           lvi_gap   := lvi_pos2 - lvi_pos1;

           LVS_MAGAZINE_BARCODE := LVS_MAGAZINE_BARCODE||SUBSTR(P_BOX_BARCODE, lvi_pos1+4, lvi_gap-4);

  ELSIF SUBSTR(P_BOX_BARCODE, 1,6) = 'AD-TAS' THEN

  ------------------------------------------------------------------------------------------------------------
  -- LG ？？？
  -- "AD-TAS@MKCM-N031A@A0_001@2016051161693@2016-05-11 13:27@60@10000@"
  --                           -------------
  ------------------------------------------------------------------------------------------------------------

           LVS_MAGAZINE_BARCODE := SUBSTR(P_BOX_BARCODE,26,13);

  ELSE

     -- BARCODE SIZE ？？？
     BEGIN

        SELECT NVL(LENGTH(P_BOX_BARCODE),0)
          INTO LVS_BARCODE_LENGTH
          FROM DUAL;

     EXCEPTION
         WHEN OTHERS THEN
              NULL;
     END;


     CASE LVS_BARCODE_LENGTH

          WHEN 12 THEN
               LVS_MAGAZINE_BARCODE := P_BOX_BARCODE;                                          -- DY,        "201605052488"

     END CASE;

  END IF;

  RETURN LVS_MAGAZINE_BARCODE;


EXCEPTION

   WHEN OTHERS THEN
       RETURN P_BOX_BARCODE;

END;