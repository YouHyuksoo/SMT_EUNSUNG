FUNCTION "F_GET_SOLDER_TYPE" (p_item_code IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_solder_type   VARCHAR2(10);
/******************************************************************************
   NAME:       f_get_solder_type
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2015-10-13   hsyou_000       1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     f_get_solder_type
      Sysdate:         2015-10-13
      Date and Time:   2015-10-13, ？？？ 5:17:40, and 2015-10-13 ？？？ 5:17:40
      Username:        hsyou_000 (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   SELECT SOLDER_TYPE
     INTO LVS_SOLDER_TYPE
     FROM ID_ITEM
    WHERE ITEM_CODE = P_ITEM_CODE;

   RETURN LVS_SOLDER_TYPE;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END f_get_solder_type;