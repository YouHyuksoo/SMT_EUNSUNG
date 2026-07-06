TRIGGER "INFINITY21_JSMES".TIGIQ_MACHINE_INS_DATA_RW_INS
 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_RW
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
   LVI_COUNT NUMBER ;
   LVS_RUN_NO VARCHAR2(30);
   
    LVS_OUT             VARCHAR2(4000); 
    LVS_MSG             VARCHAR2(4000);    
    
BEGIN
  
    
    ------------------------------------------------------------
    -- 해당라인의 진행중인 RUN NO을 가져온다
    ------------------------------------------------------------
    
    /*
    
    IF :NEW.EQUIPMENTID = '1-F' THEN 
       :NEW.LINE_CODE := '02' ;
     ELSIF :NEW.EQUIPMENTID = '1-R' THEN 
        :NEW.LINE_CODE := '01' ; 
     END IF ;
     
    BEGIN
      
       SELECT RUN_NO
         INTO :NEW.RUN_NO
         FROM IP_PRODUCT_LINE
        WHERE LINE_CODE       = :NEW.LINE_CODE
          AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID; 
      
    EXCEPTION
       WHEN OTHERS THEN
            NULL;  
    END;
    
    */

 ----------------------------------------------------------------------------
 -- 
 ----------------------------------------------------------------------------
      
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
           
  --  END IF;
          

    :NEW.INSPECT_DATE := to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS');
                         
    :new.pid := nvl(:new.pid, 'NULL') ;
                         
    :NEW.EQUIPMENTID := NVL(:NEW.EQUIPMENTID , '*') ;                         
    :NEW.CSTID  := regexp_substr(:NEW.PID,'[^-]+',1,1);                     
    :NEW.SEQ_NO := substr(regexp_substr(:NEW.PID,'[^-]+',1,2),1,2);
    :NEW.SEQ_NO := NVL(:NEW.SEQ_NO , '00' ) ;                                     
 
    ------------------------------------------------------------
    -- 최종데이타만 남도록 삭제
    ------------------------------------------------------------

 --   DELETE IQ_MACHINE_INSPECT_DATA_RW
 --    WHERE PID             = :NEW.PID
 --      AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID; 
 
 
    ------------------------------------------------------------
    -- 롬라우트 JIG 사용횟수 반영
    ------------------------------------------------------------
    
  update imcn_jig
     set hit_value = hit_value +1
   where jig_lot_no in (
                        select romwrite_lot_no
                          from ip_product_line
                         where line_code = :NEW.LINE_CODE
                           and 0 = (
                                     select count(*)
                                       from IQ_MACHINE_INSPECT_DATA_RW
                                      where PID        like :NEW.CSTID||'%'
                                        and line_code  = :NEW.LINE_CODE
                                        and enter_date >= ( sysdate - (0.5/24))
                                   )
                      );                      
       
--  ------------------------------------------------------------------------------
-- --실적취합 프로시져 호출 
-- ------------------------------------------------------------------------------
-- 
--             P_SET_WORKSTAGE_SCAN_IN(   
--                                        :NEW.PID,         --  P_SERIAL    IN VARCHAR2, 
--                                        :NEW.LINE_CODE,   --  P_LINE      IN VARCHAR2, 
--                                        'W110',           --  P_WORKSTAGE IN VARCHAR2, 
--                                        1,                --  P_ORGID     IN NUMBER, 
--                                        'I',              --  P_TYPE      IN VARCHAR2, 
--                                        LVS_OUT,          --  P_OUT       OUT VARCHAR2, 
--                                        LVS_MSG           --  P_MSG       OUT VARCHAR2
--                                  ) ;      
                                  
              
EXCEPTION
    WHEN OTHERS THEN
   
        raise_application_error (
                                 -20003, 
                                 'RW INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
END;