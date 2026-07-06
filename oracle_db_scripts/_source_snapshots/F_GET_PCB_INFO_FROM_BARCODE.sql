FUNCTION "F_GET_PCB_INFO_FROM_BARCODE" (
   p_barcode IN VARCHAR2,
   P_type IN VARCHAR2)
   RETURN VARCHAR2
IS

   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;

   lvi_gap      NUMBER;
   lvs_return   VARCHAR2 (500);

   lvs_type     VARCHAR2 (10);

BEGIN

   ---------------------------------------------------------
   --  2016/08/19 SHS, PCB ？？？？？？ ？？ keyboard ？？¿？？？ barcode scan ？？？？？？？？？濡 ？？？？ ？？？？ ？？？？？ ？？？？
   --
   -- [)>06P9102080081ZZD20160629SB00012VH4WRL20161229I20161229Q28T160629UEAXCIRCUIT BOARD(SNKCE G20160707
   --
   -- [)>@06@12S0002@P1038000678@1PP04D133A@31PP04D133A@12V662924471@10VCHN-ZHONGSHAN@2P@20PPROBIMER-77MA-1@6D20160526@14D20170507@30PN@ZN@K0@16K0@VRBKR@3SS216052671144@Q50NAR000@20T1@1T84201-1916@2T@1Z@@
   --
   -- 9103160102,160721A031,SKQ0,0050
   --
   -- [)>06P9101190168ZZD20160820SB00013VH4WRL20170220I20170220Q80T160820UEAXCIRCUIT BOARD(SNKCE G20160822]
   --
   -- S0000000000
   -- H0000000000
   -- P0000000000
   -- V0000000000
   -- Q0000000000
   --
   ---------------------------------------------------------

   IF SUBSTR(p_barcode, 1,6) = '[)>@06' THEN

      -- BOSCH 2D Barcode
      CASE p_type WHEN 'S' THEN

                        lvi_pos1  := INSTR (p_barcode, '@1T');
                        lvi_pos2  := INSTR (p_barcode, '@', lvi_pos1+1);
                        lvi_gap   := lvi_pos2 - lvi_pos1;

                        lvs_return := SUBSTR(p_barcode, lvi_pos1+3, lvi_gap-3);

                  WHEN 'P' THEN

                        lvi_pos1  := INSTR (p_barcode, '@P');
                        lvi_pos2  := INSTR (p_barcode, '@', lvi_pos1+1);
                        lvi_gap   := lvi_pos2 - lvi_pos1;

                        lvs_return := SUBSTR(p_barcode, lvi_pos1+2, lvi_gap-2);

                  WHEN 'V' THEN

                        lvi_pos1  := INSTR (p_barcode, '@V');
                        lvi_pos2  := INSTR (p_barcode, '@', lvi_pos1+1);
                        lvi_gap   := lvi_pos2 - lvi_pos1;

                        lvs_return := SUBSTR(p_barcode, lvi_pos1+2, lvi_gap-2);

                  WHEN 'Q' THEN

                        lvi_pos1  := INSTR (p_barcode, '@Q');
                        lvi_pos2  := INSTR (p_barcode, 'NAR000', lvi_pos1+1);
                        lvi_gap   := lvi_pos2 - lvi_pos1;

                    --    lvs_return := SUBSTR(SUBSTR(p_barcode, lvi_pos1+2, lvi_gap-2),1,2);  -- value ？？ Q50NAR000 ？？？？？？ ？？？？？？ o？？
                        lvs_return := SUBSTR(p_barcode, lvi_pos1+2, lvi_gap-2);
                  ELSE
                        lvs_return := 'ERROR TYPE';
      END CASE;

   ELSIF SUBSTR(p_barcode, 1,6) = '[)>'||CHR(30)||'06' THEN

            CASE p_type WHEN 'S' THEN

                              lvi_pos1  := INSTR (p_barcode, CHR(29)||'S');
                              lvi_pos2  := INSTR (p_barcode, CHR(29), lvi_pos1+1);
                              lvi_gap   := lvi_pos2 - lvi_pos1;

                              lvs_return := SUBSTR(p_barcode, lvi_pos1+2, lvi_gap-2);

                        WHEN 'P' THEN

                              lvi_pos1  := INSTR (p_barcode, CHR(29)||'P');
                              lvi_pos2  := INSTR (p_barcode, CHR(29), lvi_pos1+1);
                              lvi_gap   := lvi_pos2 - lvi_pos1;

                              lvs_return := REPLACE(SUBSTR(p_barcode, lvi_pos1+2, lvi_gap-2),'ZZ','');  -- value ？？？？ ZZ？？ ？？？？？？？？'' o？？？

                       WHEN 'V' THEN

                             lvi_pos1  := INSTR (p_barcode, CHR(29)||'V');
                             lvi_pos2  := INSTR (p_barcode, CHR(29), lvi_pos1+1);
                             lvi_gap   := lvi_pos2 - lvi_pos1;

                             lvs_return := SUBSTR(p_barcode, lvi_pos1+2, lvi_gap-2);

                       WHEN 'Q' THEN

                             lvi_pos1  := INSTR (p_barcode, CHR(29)||'Q');
                             lvi_pos2  := INSTR (p_barcode, CHR(29), lvi_pos1+1);
                             lvi_gap   := lvi_pos2 - lvi_pos1;

                             lvs_return := SUBSTR(p_barcode, lvi_pos1+2, lvi_gap-2);

                       ELSE
                             lvs_return := 'ERROR TYPE';

           END CASE;

   ELSIF SUBSTR(p_barcode, 1,5) = '[)>06' THEN

            CASE p_type WHEN 'S' THEN

                              lvi_pos1  := INSTR (p_barcode, 'S');
                              lvi_pos2  := INSTR (p_barcode, 'V', lvi_pos1+1);
                              lvi_gap   := lvi_pos2 - lvi_pos1;

                              lvs_return := SUBSTR(p_barcode, lvi_pos1+1, lvi_gap-1);

                        WHEN 'P' THEN

                              lvi_pos1  := INSTR (p_barcode, 'P');
                              lvi_pos2  := INSTR (p_barcode, 'D', lvi_pos1+1);
                              lvi_gap   := lvi_pos2 - lvi_pos1;

                              lvs_return := REPLACE(SUBSTR(p_barcode, lvi_pos1+1, lvi_gap-1),'ZZ','');  -- value ？？？？ ZZ？？ ？？？？？？？？'' o？？？

                       WHEN 'V' THEN

                             lvi_pos1  := INSTR (p_barcode, 'V');
                             lvi_pos2  := INSTR (p_barcode, 'L', lvi_pos1+1);
                             lvi_gap   := lvi_pos2 - lvi_pos1;

                             lvs_return := SUBSTR(p_barcode, lvi_pos1+1, lvi_gap-1);

                       WHEN 'Q' THEN

                             lvi_pos1  := INSTR (p_barcode, 'Q');
                             lvi_pos2  := INSTR (p_barcode, 'T', lvi_pos1+1);
                             lvi_gap   := lvi_pos2 - lvi_pos1;

                             lvs_return := SUBSTR(p_barcode, lvi_pos1+1, lvi_gap-1);

                       ELSE
                             lvs_return := 'ERROR TYPE';

           END CASE;

   ELSIF REGEXP_COUNT(p_barcode, ',') = 3 THEN

       -- KEFICO HYUNDAE 1D Barcode
             CASE p_type WHEN 'S' THEN

                              lvi_pos1  := INSTR (p_barcode, ',', 1, 1);
                              lvi_pos2  := INSTR (p_barcode, ',', 1, 2);
                              lvi_gap   := lvi_pos2 - lvi_pos1;

                              lvs_return := SUBSTR(p_barcode, lvi_pos1+1, lvi_gap-1);

                         WHEN 'P' THEN

                              lvi_pos1  := 0;
                              lvi_pos2  := INSTR (p_barcode, ',', 1, 1);
                              lvi_gap   := lvi_pos2 - lvi_pos1;

                              lvs_return := SUBSTR(p_barcode, lvi_pos1+1, lvi_gap-1);

                        WHEN 'V' THEN

                              lvi_pos1  := INSTR (p_barcode, ',', 1, 2);
                              lvi_pos2  := INSTR (p_barcode, ',', 1, 3);
                              lvi_gap   := lvi_pos2 - lvi_pos1;

                              lvs_return := SUBSTR(p_barcode, lvi_pos1+1, lvi_gap-1);

                        WHEN 'Q' THEN

                              lvi_pos1  := INSTR (p_barcode, ',', 1, 3);
                              lvi_pos2  := length (p_barcode) +1;
                              lvi_gap   := lvi_pos2 - lvi_pos1;

                              lvs_return := SUBSTR(p_barcode, lvi_pos1+1, lvi_gap-1);

                        ELSE
                             lvs_return := 'ERROR TYPE';

              END CASE;

   ELSIF P_type in ('P','V','Q','S') THEN

                -- ？？？？ 1D Barcode

                CASE P_type WHEN 'S' THEN

                                   IF  SUBSTR(p_barcode, 1,1) in ('S','H') THEN
                                       lvs_return := substr(p_barcode, 2);
                                   ELSE
                                       lvs_return := 'ERROR BARCODE';
                                   END IF;

                             WHEN 'P' THEN

                                   IF  SUBSTR(p_barcode, 1,1) = 'P' THEN
                                       lvs_return := substr(p_barcode, 2);
                                   ELSE
                                       lvs_return := 'ERROR BARCODE';
                                   END IF;

                             WHEN 'V' THEN

                                   IF  SUBSTR(p_barcode, 1,1) = 'V' THEN
                                       lvs_return := substr(p_barcode, 2);
                                   ELSE
                                       lvs_return := 'ERROR BARCODE';
                                   END IF;

                             WHEN 'Q' THEN

                                   IF  SUBSTR(p_barcode, 1,1) = 'Q' THEN
                                       lvs_return := substr(p_barcode, 2);
                                   ELSE
                                       lvs_return := 'ERROR BARCODE';
                                   END IF;

                             ELSE
                                  lvs_return := 'ERROR TYPE';

                 END CASE;

   ELSE

      lvs_return := 'BARCODE FORMAT ERROR';

   END iF;


  RETURN lvs_return;

EXCEPTION

   WHEN OTHERS
   THEN
      RETURN p_barcode;

END;