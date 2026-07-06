FUNCTION "F_GET_ITEMNAME_FROM_BARCODE" (p_barcode IN VARCHAR2)
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
--    [)>_06
--    _P9422000155ZZ
--    _D20141025
--    _SB00001
--    _VSMGW-EUR
--    _L20241025
--    _I20161025
--    _Q2368
--    _T1443
--    _UEA
--    _XIC;BSP752R-PBF
--    _N？？？？
--    _G20141025__
    ------------------------------------------------------------------

    IF SUBSTR (p_barcode, 1, 1) = '['
    THEN
        lvi_pos1 :=
            INSTR (p_barcode,
                   CHR (29),
                   1,
                   10);
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