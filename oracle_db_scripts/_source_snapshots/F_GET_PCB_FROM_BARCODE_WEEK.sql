FUNCTION "F_GET_PCB_FROM_BARCODE_WEEK" (p_item_code IN VARCHAR2,
                                                        p_barcode   IN VARCHAR2 )
    RETURN VARCHAR2
IS
    lvi_pos1     NUMBER;
    lvi_pos2     NUMBER;
    lvi_pos3     NUMBER;
    lvi_pos4     NUMBER;

    lvl_strvalue NUMBER;
    lvl_endvalue NUMBER;
    lvs_return   VARCHAR2 (30);
BEGIN
------------------------------------------------------------------
-- PCB WEEK ？？
------------------------------------------------------------------

    lvi_pos1 := INSTR (p_barcode, '!', 1, 1);
    lvi_pos2 := INSTR (p_barcode, '!', 1, 2);
    lvi_pos3 := INSTR (p_barcode, '!', 1, 3);
    lvi_pos4 := INSTR (p_barcode, '!', 1, 4);


    SELECT STR_VALUE, END_VALUE
      INTO lvl_strvalue, lvl_endvalue
      FROM IM_ITEM_WEEK
     WHERE ITEM_CODE = p_item_code;

    lvs_return := substr( p_barcode , lvi_pos3 + lvl_strvalue , lvl_endvalue  ) ;


    RETURN lvs_return;

EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN NULL;
    WHEN OTHERS
    THEN
        RETURN NULL;
END;