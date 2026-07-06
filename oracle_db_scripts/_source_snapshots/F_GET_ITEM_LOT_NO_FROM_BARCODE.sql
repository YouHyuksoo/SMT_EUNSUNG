FUNCTION "F_GET_ITEM_LOT_NO_FROM_BARCODE" (
    p_barcode IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (100);
    lvi_pos_exists NUMBER ; 
    lvi_pos1     NUMBER;
BEGIN
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


    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN NULL;
END;