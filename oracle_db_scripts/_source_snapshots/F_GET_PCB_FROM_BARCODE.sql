FUNCTION "F_GET_PCB_FROM_BARCODE" (p_barcode IN VARCHAR2,
                                                p_gbn     IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvi_pos1     NUMBER;
    lvi_pos2     NUMBER;
    lvi_pos3     NUMBER;
    lvi_pos4     NUMBER;

    lvs_return   VARCHAR2 (30);
BEGIN
------------------------------------------------------------------
-- PCB LOT_NO, WEEK ？？
------------------------------------------------------------------

    lvi_pos1 := INSTR (p_barcode, '!', 1, 1);
    lvi_pos2 := INSTR (p_barcode, '!', 1, 2);
    lvi_pos3 := INSTR (p_barcode, '!', 1, 3);
    lvi_pos4 := INSTR (p_barcode, '!', 1, 4);

    IF p_gbn = 'L'    -- LOT NO
    THEN
       lvs_return := substr( p_barcode , lvi_pos2 + 1 , (lvi_pos3 - 1) - lvi_pos2  ) ;
    ELSIF p_gbn = 'W' -- WEEK
    THEN
       lvs_return := substr( p_barcode , lvi_pos3 + 1 , (lvi_pos4 - 1) - lvi_pos3  ) ;
    ELSE
       lvs_return := '';
    END IF;


    RETURN lvs_return;

EXCEPTION
    WHEN OTHERS
    THEN
        RETURN NULL;
END;