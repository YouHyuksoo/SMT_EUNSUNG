FUNCTION "F_CHECK_VENDOR_LOTNO_BLOKING" (
   P_MODEL_NAME   IN VARCHAR2,
   P_ITEM_CODE    IN VARCHAR2,
   P_LOT_NO       IN VARCHAR2)
   RETURN NUMBER
IS
   LVI_COUNT          NUMBER;
   LVI_ITEM_CHECK     NUMBER;
   LVS_VENDOR_LOTNO   VARCHAR2 (50);
BEGIN
   --------------------------------------------
   -- ？？？？？？？？？？ ？？？？？？ u？？
   --------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO LVI_ITEM_CHECK
        FROM IQ_SUPPLIER_LOT_BLOKING
       WHERE MODEL_NAME = P_MODEL_NAME AND ITEM_CODE = P_ITEM_CODE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;


   IF NVL (LVI_ITEM_CHECK, 0) = 0
   THEN
      RETURN 0;
   END IF;

   --------------------------------------------
   -- ？？？？？？？？？？ ？？？？？？ ？？？？？？ ？？？？？？？？？？
   -- ？？？？ ？？？？？？？？？？ ？？？？？？？？？？？？？？？？
   --------------------------------------------

   BEGIN
      SELECT VENDOR_LOTNO
        INTO LVS_VENDOR_LOTNO
        FROM IM_ITEM_RECEIPT_BARCODE
       WHERE LOT_NO = P_LOT_NO;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;


   IF NVL (LVS_VENDOR_LOTNO, '*') = '*'
   THEN
      RETURN 110; --？？？？？？？？ o？？？？
   END IF;


   --------------------------------------------
   --  ？？？？？？？？？？？？？？ ？？？？ ？？？？？？？？？ u？？
   --
   --------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IQ_SUPPLIER_LOT_BLOKING
       WHERE MODEL_NAME = P_MODEL_NAME AND ITEM_CODE = P_ITEM_CODE
             AND UPPER(VENDOR_LOTNO)  = SUBSTR (UPPER(LVS_VENDOR_LOTNO), 1, LENGTH (VENDOR_LOTNO))
             AND ROWNUM = 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 120;
   END;

   -------------------------------------
   --  ？？？？？？？？？？K
   -------------------------------------
   IF NVL(LVI_COUNT,0)  > 0
   THEN
      RETURN 0;
   ELSE
      RETURN 130;
   END IF;
----------------------------------------------------------------
--
----------------------------------------------------------------
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 140;
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END;