TRIGGER TIGIQ_MACHINE_INS_DATA_EOL_INS
 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_EOL
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
 
    
BEGIN
  
     --*************************************************
     -- runcard 확인
     --*************************************************
      
             
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
         
   
    :new.pid    := nvl(:new.pid, 'NULL') ;
                                                                

                                                                 
                                       
EXCEPTION
    WHEN OTHERS THEN
   
        raise_application_error (
                                 -20003, 
                                 'EOL INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
END;
