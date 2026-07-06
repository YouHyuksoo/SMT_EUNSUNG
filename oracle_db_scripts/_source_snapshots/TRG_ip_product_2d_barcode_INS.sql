TRIGGER "TRG_ip_product_2d_barcode_INS"
  before insert on ip_product_2d_barcode
  for each row
declare
  
  lvs_box_no    varchar2(100);
  
begin
  
   -- Pack serial 생성시 box_no 확인

   BEGIN
   
      SELECT PACK_BARCODE
        INTO lvs_box_no
        FROM IP_PRODUCT_PACK_SERIAL
       WHERE BARCODE = :NEW.SERIAL_NO
         AND ROWNUM  = 1;
       
   EXCEPTION
      WHEN OTHERS THEN
           lvs_box_no := NULL; 
   END;
      
   :new.box_no          := lvs_box_no;
   :new.enter_by        := 'TRG INS 2D BCR';
   :new.last_modify_by  := 'TRG INS 2D BCR';
   
  
end;
