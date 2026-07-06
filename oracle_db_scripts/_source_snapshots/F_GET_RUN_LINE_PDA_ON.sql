FUNCTION F_GET_RUN_LINE_PDA_ON
(
   P_RUN_NO    IN VARCHAR2 
,  P_LINE      IN VARCHAR2
, P_ORG       IN NUMBER 
) RETURN DATE AS 


LVL_RETURN DATE ;

BEGIN

 LVL_RETURN := NULL;
 
   ------------------------------------------------------------
  -- LINE_ONOFF = 'ON' : 해당 run no 장착
  ------------------------------------------------------------   
  
  SELECT MAX( LINE_ONOFF_DATE )
    INTO LVL_RETURN
    FROM IB_SMT_LINE_ONOFF_HISTORY
   WHERE RUN_NO          = P_RUN_NO
     AND LINE_CODE       = P_LINE
     AND LINE_ONOFF      = 'ON'
     AND ORGANIZATION_ID = P_ORG;    
    
  RETURN LVL_RETURN;
  
  
EXCEPTION WHEN NO_DATA_FOUND THEN 
     RETURN NULL ;
    
END;
