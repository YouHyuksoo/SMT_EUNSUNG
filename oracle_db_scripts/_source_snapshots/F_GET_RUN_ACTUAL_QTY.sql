FUNCTION F_GET_RUN_ACTUAL_QTY
(
  P_RUN_NO IN VARCHAR2 
, P_ORG IN NUMBER 
) RETURN NUMBER AS 


LVL_RETURN NUMBER ;

BEGIN

  LVL_RETURN := 0;
  ------------------------------------------------------------
  -- aoi 실적을 생산 실적으로 집계
  ------------------------------------------------------------
  SELECT count(pid)
    INTO LVL_RETURN 
    FROM IQ_MACHINE_INSPECT_DATA_AOI
   WHERE RUN_NO = P_RUN_NO 
     AND ORGANIZATION_ID = P_ORG ;
   
  RETURN LVL_RETURN;
  
  
EXCEPTION 
   WHEN NO_DATA_FOUND THEN 
        RETURN 0 ;
    
END F_GET_RUN_ACTUAL_QTY;