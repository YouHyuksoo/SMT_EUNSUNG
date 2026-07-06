FUNCTION "F_GET_MODEL_MARKING_CONDITION" (
                                                             P_MODEL_NAME   IN VARCHAR2,
                                                             P_ORG          IN NUMBER
                                                           ) RETURN VARCHAR2
IS
   LVS_CONDITION   VARCHAR2(10);
BEGIN
  
   LVS_CONDITION := '*';

      SELECT MAX(marking_condition)
        INTO LVS_CONDITION
        FROM ip_product_model_master
       WHERE MODEL_NAME      = P_MODEL_NAME
         AND ORGANIZATION_ID = P_ORG;             
             
     --임시 처리 나중에 삭제           
 
   RETURN NVL (LVS_CONDITION, '*');
   
EXCEPTION
   WHEN NO_DATA_FOUND THEN
        LVS_CONDITION := '*';
        
   WHEN OTHERS THEN
        LVS_CONDITION :=  '*';
END ;
