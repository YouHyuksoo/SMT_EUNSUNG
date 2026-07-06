FUNCTION "F_GET_ITEM_CODE_FROM_BARCODE_B" (
   p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
lvi_pos_exists NUMBER ;
   lvi_gap      NUMBER;
   lvs_return   VARCHAR2 (30);
   lvs_barcode varchar2(100) ;
BEGIN
   ---------------------------------------------------------
   --
   ---------------------------------------------------------
   lvs_barcode := p_barcode ; 
   
   if substr( lvs_barcode , 1,1)  = 'P' then 
       lvs_barcode := trim(substr(lvs_barcode , 2, 100)) ;
   end if ;
  if substr( lvs_barcode , 1,1)  = ' ' then 
       lvs_barcode := trim(substr(lvs_barcode , 2, 100)) ;
   end if ;  
    if substr( lvs_barcode , 1,2)  = 'SA' then 
       lvs_barcode := trim(substr(lvs_barcode , 3, 100)) ;
   end if ;
   
   
   --------------------------------------------------------
   --
   --------------------------------------------------------
    lvi_pos_exists := INSTR (p_barcode, '-', 1,1) ;
    lvi_pos1 := INSTR (p_barcode, '-', 1,3);

    -- 없으면 
    IF lvi_pos_exists = 0
    THEN
        lvs_return := TRIM (SUBSTR (p_barcode, 1, 100));
    ELSIF lvi_pos_exists > 0 AND  lvi_pos1 = 0 
    THEN -- 두개짜리 바코드 
        lvs_return := TRIM (SUBSTR (p_barcode, 1, INSTR (p_barcode, '-', 1,1) - 1));
    ELSIF  lvi_pos_exists > 0 AND  lvi_pos1  > 0   -- 3개짜리 바코드 면 두번째 - 까지 품목 코드로 구분 
    THEN
        lvs_return := TRIM (SUBSTR (p_barcode, 1, INSTR (p_barcode, '-', 1,2) - 1));
    END IF;
   
EXCEPTION
   WHEN OTHERS THEN
        RETURN lvs_barcode;
END;