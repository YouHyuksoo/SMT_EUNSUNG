TRIGGER "INFINITY21_JSMES".TIGIQ_MACHINE_INS_DATA_RT_INS
 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_RT
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE

   LVI_COUNT NUMBER ;
   LVS_RUN_NO VARCHAR2(30);
   
   LVS_OUT             VARCHAR2(4000); 
   LVS_MSG             VARCHAR2(4000); 
    
BEGIN
  
  --  IF ( :NEW.RUN_NO = 'NULL' OR :NEW.RUN_NO = ''  OR :NEW.RUN_NO IS NULL ) THEN
           
              BEGIN
                 
                  SELECT RUN_NO
                    INTO :NEW.RUN_NO
                    FROM IP_PRODUCT_2D_BARCODE
                   WHERE serial_no       = :NEW.PID
                     AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;     
                  
               EXCEPTION 
                     WHEN OTHERS THEN 
                          :NEW.RUN_NO := 'NULL';
               END;
           
 --   END IF;
    
     :new.pid    := nvl(:new.pid, 'NULL') ;                                
 
    ------------------------------------------------------------
    -- 최종데이타만 남도록 삭제
    ------------------------------------------------------------

/*    
    DELETE IQ_MACHINE_INSPECT_DATA_RT
     WHERE PID             = :NEW.PID
       AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID; 
       
    DELETE IQ_MACHINE_INSPECT_DATA_RT
     WHERE PID             = 'NULL' ;  
 */ 
 
--  ------------------------------------------------------------------------------
-- --실적취합 프로시져 호출 
-- ------------------------------------------------------------------------------
-- 
--             P_SET_WORKSTAGE_SCAN_IN(   
--                                        :NEW.PID,         --  P_SERIAL    IN VARCHAR2, 
--                                        :NEW.LINE_CODE,   --  P_LINE      IN VARCHAR2, 
--                                        'W100',           --  P_WORKSTAGE IN VARCHAR2, 
--                                        1,                --  P_ORGID     IN NUMBER, 
--                                        'I',              --  P_TYPE      IN VARCHAR2, 
--                                        LVS_OUT,          --  P_OUT       OUT VARCHAR2, 
--                                        LVS_MSG           --  P_MSG       OUT VARCHAR2
--                                  ) ;      
--                                   

EXCEPTION
    WHEN OTHERS THEN
   
        raise_application_error (
                                 -20003, 
                                 'ROUTER INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
END;