TRIGGER TIGIQ_MACHINE_INS_DATA_BMA_INS
 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_BMA
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    
    LVS_OUT             VARCHAR2(4000); 
    LVS_MSG             VARCHAR2(4000); 
    LVS_WORKSTAGE_CODE  VARCHAR2(30);  
  

  
BEGIN
  

    IF ( :NEW.RUN_NO = 'NULL' OR :NEW.RUN_NO = ''  OR :NEW.RUN_NO IS NULL OR :NEW.RUN_NO = '*') THEN
           
              BEGIN
                 
                  SELECT RUN_NO
                    INTO :NEW.RUN_NO
                    FROM IP_PRODUCT_2D_BARCODE
                   WHERE serial_no       = :NEW.PID
                     AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;     
                  
               EXCEPTION 
                  WHEN OTHERS THEN 
                          :NEW.RUN_NO    := '*';   
                          
               END;
           
   END IF;
    
   :new.pid    := nvl(:new.pid, '*') ;

      

EXCEPTION
    WHEN OTHERS THEN
   
        raise_application_error (
                                 -20003, 
                                 'BMA INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
END;
