FUNCTION "F_CHECK_NUMBER" (p_str VARCHAR2) RETURN NUMBER
IS

   lvl_return NUMBER;

BEGIN

---------------------------------------------------------------------------------------
-- 2016/08/26 SHS, CCS, REEL, FULL ？？？？ barcode scan？？？？？？ ？？？？ ？？？ QTY check ？？？ ？？？？
---------------------------------------------------------------------------------------
   IF p_str IS NULL OR LENGTH(TRIM(p_str)) = 0 THEN

      RETURN 0;

   END IF;

   lvl_return := TO_NUMBER(p_str);

   RETURN 1;

   EXCEPTION WHEN OTHERS THEN

      RETURN 0;

END ;