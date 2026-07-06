FUNCTION "F_GET_MAT_RECEIPT_WAIT_QTY" (
   P_ITEM_CODE   IN VARCHAR2,
   P_ORG         IN NUMBER)
   RETURN NUMBER
IS
   LVL_QTY   NUMBER;
/******************************************************************************
   NAME:       F_GET_MAT_RECEIPT_WAIT_QTY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2015-12-19   hsyou_000       1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     F_GET_MAT_RECEIPT_WAIT_QTY
      Sysdate:         2015-12-19
      Date and Time:   2015-12-19, ？？？ 12:08:57, and 2015-12-19 ？？？ 12:08:57
      Username:        hsyou_000 (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   SELECT SUM (SCAN_QTY)
     INTO LVL_QTY
     FROM IM_ITEM_RECEIPT_BARCODE
    WHERE     ITEM_CODE = P_ITEM_CODE
          AND RECEIPT_COMPARE_YN = 'N'
          AND RETURN_YN = 'N'
          AND BARCODE_STATUS <> 'C'
          AND ORGANIZATION_ID = P_ORG;

   RETURN NVL (LVL_QTY, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END F_GET_MAT_RECEIPT_WAIT_QTY;