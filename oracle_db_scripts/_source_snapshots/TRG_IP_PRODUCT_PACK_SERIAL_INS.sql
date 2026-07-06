TRIGGER "TRG_IP_PRODUCT_PACK_SERIAL_INS"
  before insert on ip_product_pack_serial
  for each row
declare
  
begin
  
   -- Pack serial 생성시 box_no 에 marking
   
   update ip_product_2d_barcode
      set box_no           = :new.pack_barcode,
          last_modify_date = sysdate,
		      last_modify_by   = 'INS BF TRG',
          enter_by         = 'INS BF TRG'
    where serial_no        = :new.barcode;
    
    --  and ( box_no           is null or box_no ='') ;
    
  
end TRG_IP_PRODUCT_PACK_SERIAL_INS;
