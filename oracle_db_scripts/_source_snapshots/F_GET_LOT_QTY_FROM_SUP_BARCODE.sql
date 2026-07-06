FUNCTION "F_GET_LOT_QTY_FROM_SUP_BARCODE" (  p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS

   lvs_return   VARCHAR2 (30);
BEGIN
   ------------------------------------------------------------------
  
   ------------------------------------------------------------------
  
   lvs_return := TRIM (SUBSTR (p_barcode, 12, 5));
     
   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN NULL;
END;