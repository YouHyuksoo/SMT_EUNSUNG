FUNCTION "F_GET_MODEL_PRODUCT_ST" (
   P_MODEL_NAME   IN VARCHAR2,
   P_LINE_CODE    IN VARCHAR2,
    P_TYPE         IN VARCHAR2,
   p_workstage_code IN VARCHAR2 ,
  
   P_ORG          IN NUMBER)
   RETURN NUMBER
IS
   LVL_ST   NUMBER;
BEGIN
   LVL_ST := 0;

      SELECT MAX(PRODUCT_ST)
        INTO LVL_ST
        FROM IP_PRODUCT_MODEL_ST_MASTER
       WHERE     MODEL_NAME = P_MODEL_NAME
             AND LINE_CODE  = P_LINE_CODE
             and WORKSTAGE_CODE = p_workstage_code
             AND ORGANIZATION_ID = P_ORG;
             
     --임시 처리 나중에 삭제           
      IF LVL_ST = 0 OR LVL_ST IS NULL THEN 
           LVL_ST := 20 ;
      END IF ;
 
   RETURN NVL (LVL_ST, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      LVL_ST := 0;
   WHEN OTHERS
   THEN
      LVL_ST := 0;
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END ;