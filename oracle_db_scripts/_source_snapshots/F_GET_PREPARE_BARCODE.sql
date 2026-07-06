FUNCTION "F_GET_PREPARE_BARCODE" (
   p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (100);
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
BEGIN

------------------------------------------------------------------
--
------------------------------------------------------------------
      lvs_return :=   TRIM(SUBSTR (UPPER (p_barcode), 1, 100));

   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN p_barcode;
END;