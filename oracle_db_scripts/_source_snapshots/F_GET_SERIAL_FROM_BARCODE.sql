FUNCTION "F_GET_SERIAL_FROM_BARCODE" (p_barcode IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvi_pos1     NUMBER;
    lvi_pos2     NUMBER;


    lvi_gap      NUMBER;
    lvs_return   VARCHAR2 (30);
BEGIN

        lvs_return := '*';
  
    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN NULL;
END;