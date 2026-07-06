TRIGGER "INFINITY21_JSMES"."TRGIP_PRODUCT_WORK_QC_UPD" 
 BEFORE 
 UPDATE OF RECEIPT_DEFICIT
 ON IP_PRODUCT_WORK_QC
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
DECLARE
   lvi_count               NUMBER;

BEGIN
   ---------------------------------------
   -- 출고인경우
   ---------------------------------------
   IF :OLD.RECEIPT_DEFICIT <> :NEW.RECEIPT_DEFICIT    AND :NEW.RECEIPT_DEFICIT = '2'
   THEN
    
       --BARCODE_STATUS  N :정상 , D : 폐기 , R : 수리품  , B : 불량품  , X : 엑스아웃 

        UPDATE ip_product_2d_barcode SET BARCODE_STATUS = 'R' 
        WHERE serial_no = :new.serial_no 
          AND BARCODE_STATUS <> 'X' ;
        
        UPDATE IQ_PRODUCT_WQC 
           SET REPAIR_RECEIPT_DEFICIT = '2' ,
               REPAIR_DATE = SYSDATE 
        WHERE SERIAL_NO = :NEW.SERIAL_NO ;    
  
   ELSE  

         --------------------------------------------------------------
         -- 출고 했다가 취소 한 겨우

         IF     :OLD.RECEIPT_DEFICIT <> :NEW.RECEIPT_DEFICIT   AND :NEW.RECEIPT_DEFICIT = '1'      AND :NEW.QC_INSPECT_HANDLING <> 'D'
         THEN
           
               --BARCODE_STATUS  N :정상 , D : 폐기 , R : 수리품  , B : 불량품 , X : 엑스아웃 
              
              UPDATE ip_product_2d_barcode SET BARCODE_STATUS = 'B' 
              WHERE serial_no = :new.serial_no 
                AND BARCODE_STATUS <> 'X' ;
              
              UPDATE IQ_PRODUCT_WQC SET REPAIR_RECEIPT_DEFICIT = '1' , REPAIR_DATE = SYSDATE 
              WHERE SERIAL_NO = :NEW.SERIAL_NO ;               
                   
     
     END IF;
END IF ;


END ;