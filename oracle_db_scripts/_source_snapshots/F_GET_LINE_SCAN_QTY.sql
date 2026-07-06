FUNCTION "F_GET_LINE_SCAN_QTY" (p_item_code   IN VARCHAR2,
                             p_line_code          IN VARCHAR2,
                             p_org                IN NUMBER)
   RETURN NUMBER
IS
   lvl_return   NUMBER;
BEGIN
   SELECT NVL(SUM(SCAN_QTY),0)
     INTO lvl_return
     FROM IM_ITEM_RECEIPT_BARCODE
    WHERE ITEM_CODE       = p_item_code
      AND LINE_CODE       = p_line_code
      AND ORGANIZATION_ID = p_org
      AND RECEIPT_COMPARE_YN = 'Y'
      AND ISSUE_COMPARE_YN   = 'Y'
      AND FEEDING_YN         = 'N'  ;

   RETURN lvl_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;