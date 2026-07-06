TRIGGER "INFINITY21_JSMES"."TRGIQ_PRODUCT_WQC_INS" 
 BEFORE
  INSERT
 ON IQ_PRODUCT_WQC
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN 


--BARCODE_STATUS  N :정상 , D : 폐기 , R : 수리품  , B : 불량품 

    UPDATE ip_product_2d_barcode SET BARCODE_STATUS = 'B' 
     WHERE serial_no = :new.serial_no ;
     
     


END ;