FUNCTION "F_GET_LOT_QTY_FROM_BARCODE" (
   p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
lvi_pos3 NUMBER ;

   lvi_gap      NUMBER;
   lvs_return   VARCHAR2 (30);
BEGIN
   ------------------------------------------------------------------
  
   ------------------------------------------------------------------
   ------------------------------------------------------------------
    -- 기본은 두개짜리 
    -- 3개짜리 인지 판단 
    ------------------------------------------------------------------

        lvi_pos1 := INSTR (p_barcode, '-', 1,1);
        lvi_pos2 := INSTR (p_barcode, '-', 1,2);
        lvi_pos3 := INSTR (p_barcode, '-', 1,3);

        -- 없으면 
        if  lvi_pos1 = 0 then
              RETURN '0' ;
        end if ;
        
        --두개짜리 
        if lvi_pos3 = 0 then 
              lvs_return := TRIM (SUBSTR (p_barcode, lvi_pos2 + 1, 10 ));
        elsif lvi_pos3 > 0 then --3개 짜리 
              lvs_return := TRIM (SUBSTR (p_barcode, lvi_pos3 + 1, 10 ));  
        end if  ;
  
   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN NULL;
END;