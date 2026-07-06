FUNCTION "F_GET_INSPECT_FROM_BARCODE" (p_barcode IN VARCHAR2)
/* Formatted on 2015-07-07 12:16:57 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvi_pos1     NUMBER;
    lvi_pos2     NUMBER;
    lvi_gap      NUMBER;
    lvs_return   VARCHAR2 (30);
BEGIN
    ------------------------------------------------------------------
    -- KEFICO
    -- 7-8 QTY
    -- [)>06P9990932163ZZD20150328SB00017VDF33L20250328I20170328Q2984TID15C26157UEAXCAPACITOR;06034N???????G20150
    ------------------------------------------------------------------

    IF SUBSTR (p_barcode, 1, 1) = '['
    THEN
        lvi_pos1 :=
            INSTR (p_barcode,
                   CHR (29),
                   1,
                   6);
        lvi_pos2 := INSTR (p_barcode, CHR (29), lvi_pos1 + 1);

        lvs_return := TRIM (SUBSTR (p_barcode, lvi_pos1 + 2, (lvi_pos2 - lvi_pos1) - 2));
    ELSE
        lvs_return := '99991231';
    END IF;

    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '99991231';
END;