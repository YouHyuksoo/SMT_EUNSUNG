FUNCTION "F_GET_TRACE_NO_FROM_BARCODE" (
   p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
   lvi_pos3     NUMBER;
   lvi_pos4     NUMBER;

   lvi_gap      NUMBER;
   lvs_return   VARCHAR2 (30);
   LVS_LOT_NO   VARCHAR2 (50);
BEGIN
   ------------------------------------------------------------------
   -- KEFICO
   -- 8 - 9 TRAACE NO = LOT NO
   -- [)>06P9990932163ZZD20150328SB00017VDF33L20250328I20170328Q2984TID15C26157UEAXCAPACITOR;06034N???????G20150
   ------------------------------------------------------------------

   IF SUBSTR (p_barcode, 1, 1) = '['
   THEN
      lvi_pos1 :=
         INSTR (p_barcode,
                CHR (29),
                1,
                8);
      lvi_pos2 := INSTR (p_barcode, CHR (29), lvi_pos1 + 1);


      lvs_return :=
         SUBSTR (p_barcode, lvi_pos1 + 2, (lvi_pos2 - lvi_pos1) - 2);
   ELSE
      BEGIN
         SELECT ORIGIN_MFS
           INTO LVS_LOT_NO
           FROM IM_ITEM_RECEIPT
          WHERE     BARCODE = p_barcode
                AND ORIGIN_MFS IS NOT NULL
                AND RECEIPT_STATUS = 'N'
                AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LVS_LOT_NO := '';
      END;

      lvs_return := NVL (LVS_LOT_NO, '');
   END IF;

   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN NULL;
END;