FUNCTION "F_GET_VENDOR_FROM_BARCODE" (p_barcode IN VARCHAR2)
/* Formatted on 2015-06-20 16:16:28 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvi_pos1     NUMBER;
    lvi_pos2     NUMBER;


    lvi_gap      NUMBER;
    lvs_return   VARCHAR2 (30);
BEGIN
    ------------------------------------------------------------------
    -- KEFICO
    -- 4-5 VENDOR
    -- [)>06P9990932163ZZD20150328SB00017VDF33L20250328I20170328Q2984TID15C26157UEAXCAPACITOR;06034N???????G20150
    ------------------------------------------------------------------

    IF SUBSTR (p_barcode, 1, 1) = '['
    THEN
        lvi_pos1 :=
            INSTR (p_barcode,
                   CHR (29),
                   1,
                   4);
        lvi_pos2 := INSTR (p_barcode, CHR (29), lvi_pos1 + 1);

        lvs_return := SUBSTR (p_barcode, lvi_pos1 + 2, (lvi_pos2 - lvi_pos1) - 2);
    ELSE
        lvs_return := '*';
    END IF;

    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN NULL;
END;