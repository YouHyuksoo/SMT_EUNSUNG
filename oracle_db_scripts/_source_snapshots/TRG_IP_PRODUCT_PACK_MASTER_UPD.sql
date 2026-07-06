TRIGGER "INFINITY21_JSMES"."TRG_IP_PRODUCT_PACK_MASTER_UPD" 
  before update of complete_flag on ip_product_pack_master  
  for each row
declare
  lvl_pack_count number; 
begin
   -- local variables here
   --  Pack 수량 Update 
  if :new.complete_flag = 'Y' then 
    SELECT COUNT(*) 
      into lvl_pack_count
      FROM IP_PRODUCT_PACK_SERIAL X 
     WHERE X.Pack_Barcode = :old.pack_barcode ; 
     
    
    :new.pack_qty := lvl_pack_count ;  
     
  end if ; 
end TRG_IP_PRODUCT_PACK_MASTER_UPD;