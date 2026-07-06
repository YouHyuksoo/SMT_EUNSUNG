FUNCTION F_GET_RUN_LINE_INPUT_QTY
(
  P_RUN_NO  IN VARCHAR2, 
  P_LINE    IN VARCHAR2,
  P_ORG     IN NUMBER 
) RETURN NUMBER AS 


LVL_RETURN NUMBER ;

BEGIN

   LVL_RETURN := 0;
   
   
     SELECT COUNT(DISTINCT PID) 
        INTO LVL_RETURN
     FROM IQ_MACHINE_INSPECT_DATA_MK
    WHERE PID IN ( SELECT SERIAL_NO FROM IP_PRODUCT_2D_BARCODE WHERE RUN_NO = P_RUN_NO ) ;
    
     RETURN LVL_RETURN;
    
    if lvl_return = 0 then 
    
    
     SELECT COUNT(DISTINCT PID) 
        INTO LVL_RETURN
     FROM IQ_MACHINE_INSPECT_DATA_SPI
    WHERE PID IN ( SELECT SERIAL_NO FROM IP_PRODUCT_2D_BARCODE WHERE RUN_NO = P_RUN_NO ) ;
    
    end if ;
    
     RETURN LVL_RETURN;
--  ------------------------------------------------------------
--  -- Route 상 io_type = 'I' 생산완성실적으로 집계
--  ------------------------------------------------------------   
--   SELECT SUM(IO_QTY)    --COUNT(*) 
--     INTO LVL_RETURN 
--     FROM IP_PRODUCT_WORKSTAGE_IO
--    WHERE LINE_CODE       = P_LINE
--      AND RUN_NO          = P_RUN_NO 
--      AND WORKSTAGE_CODE  = F_GET_WORKSTAGE_CODE_4_LINE(P_LINE, 'I')
--      AND ORGANIZATION_ID = P_ORG;
      
 
  
  
  EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
           RETURN 0 ;
    
END F_GET_RUN_LINE_INPUT_QTY;