TRIGGER "TRG_IP_PRODUCT_PACK_SERIAL_DEL"
  before delete on ip_product_pack_serial
  for each row
declare
  
begin
  
   -- Pack serial 생성시 box_no 에 marking
   
   update ip_product_2d_barcode
      set box_no           = NULL,
          last_modify_date = sysdate,
		      last_modify_by   = 'DEL BF TRG',
          enter_by         = 'DEL BF TRG'
    where serial_no        = :old.barcode;
    
    --  and box_no           IS NOT NULL;
    
  
end TRG_IP_PRODUCT_PACK_SERIAL_DEL;
