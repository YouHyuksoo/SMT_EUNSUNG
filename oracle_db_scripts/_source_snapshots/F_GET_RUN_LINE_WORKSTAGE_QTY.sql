FUNCTION F_GET_RUN_LINE_WORKSTAGE_QTY
(
  P_LINE      IN VARCHAR2
, P_WORKSTAGE IN VARCHAR2
, P_RUN_NO    IN VARCHAR2 
, P_ORG       IN NUMBER 
) RETURN NUMBER AS 


LVL_RETURN NUMBER ;

BEGIN

 LVL_RETURN := 0;
 
   ------------------------------------------------------------
  -- Route 상 io_type = 'I' 생산완성실적으로 집계
  ------------------------------------------------------------   
   SELECT SUM(IO_QTY) 
     INTO LVL_RETURN 
     FROM IP_PRODUCT_WORKSTAGE_IO
    WHERE RUN_NO          = P_RUN_NO 
      AND LINE_CODE       = P_LINE
      AND WORKSTAGE_CODE  = P_WORKSTAGE
      AND ORGANIZATION_ID = P_ORG;      
    
  RETURN LVL_RETURN;
  
  
  EXCEPTION WHEN NO_DATA_FOUND THEN 
    RETURN 0 ;
    
END F_GET_RUN_LINE_WORKSTAGE_QTY;
