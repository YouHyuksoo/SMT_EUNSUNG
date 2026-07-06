FUNCTION "F_CHECK_RECEIPT_BARCODE_EXISTS" (
   p_barcode     IN VARCHAR2,
   p_org         IN NUMBER)
   RETURN VARCHAR2
IS
   lvl_cnt   NUMBER;
BEGIN

   --------------------------------------------------------------------
   -- 2016/10/17 SHS, ？？？？？？？？？？check ？？？ ？？？翩？？return
   --------------------------------------------------------------------

   BEGIN

      SELECT COUNT(*)
        INTO lvl_cnt
        FROM IM_ITEM_RECEIPT_BARCODE
       WHERE ITEM_BARCODE    = p_barcode
         AND organization_id = p_org
         AND rownum          = 1;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           lvl_cnt := 0;
   END;


   IF lvl_cnt = 0
   THEN
      RETURN 'NOTFOUND';
   ELSE
      RETURN 'EXISTS';
   END IF;

EXCEPTION
   WHEN OTHERS THEN
        raise_application_error (-20003, SQLERRM);
END;