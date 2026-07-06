FUNCTION "F_GET_MAT_WS_REV_INV_QTY" (
   P_ITEM_CODE   IN VARCHAR2,
   P_ORG         IN NUMBER)
   RETURN NUMBER
IS
   LVL_RETURN   NUMBER;
/******************************************************************************
   NAME:       F_GET_MAT_WS_REV_INV_QTY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2015-12-30   hsyou_000       1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     F_GET_MAT_WS_REV_INV_QTY
      Sysdate:         2015-12-30
      Date and Time:   2015-12-30, ？？？ 9:12:49, and 2015-12-30 ？？？ 9:12:49
      Username:        hsyou_000 (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   LVL_RETURN := 0;


   SELECT SUM(INVENTORY_QTY) INTO LVL_RETURN
     FROM IM_ITEM_WS_INVENTORY_REVERSE
    WHERE ITEM_CODE = P_ITEM_CODE AND ORGANIZATION_ID = P_ORG;


   RETURN LVL_RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END F_GET_MAT_WS_REV_INV_QTY;