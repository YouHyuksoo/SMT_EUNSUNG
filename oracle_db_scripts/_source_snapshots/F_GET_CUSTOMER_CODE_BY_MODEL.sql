FUNCTION "F_GET_CUSTOMER_CODE_BY_MODEL" (
   P_MODEL_NAME   IN VARCHAR2
)
   RETURN VARCHAR2
IS
   LVS_CUSTOMER_CODE   VARCHAR2 (100);
/******************************************************************************
   NAME:       F_GET_CUSTOMER_NAME_BY_MODEL
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2016-10-21          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     F_GET_CUSTOMER_NAME_BY_MODEL
      Sysdate:         2016-10-21
      Date and Time:   2016-10-21, ？？？？ 3:46:40, and 2016-10-21 ？？？？ 3:46:40
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
  
   LVS_CUSTOMER_CODE := '*';

   SELECT   MAX (CUSTOMER_CODE)
     INTO   LVS_CUSTOMER_CODE
     FROM   IP_PRODUCT_MODEL_MASTER
    WHERE   MODEL_NAME = P_MODEL_NAME;


   RETURN LVS_CUSTOMER_CODE;
   
EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '*';
   WHEN OTHERS THEN
        RETURN NULL;
END F_GET_CUSTOMER_CODE_BY_MODEL;
