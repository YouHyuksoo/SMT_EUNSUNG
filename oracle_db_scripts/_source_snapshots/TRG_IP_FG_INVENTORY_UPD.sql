TRIGGER "INFINITY21_JSMES"."TRG_IP_FG_INVENTORY_UPD" 
  before update of pallet_flag on ip_product_fg_inventory  
  for each row
declare
  -- local variables here
begin
  if :new.pallet_flag = 'Y' and :old.pallet_flag = 'N' then 
    update ip_product_pack_master x 
       set x.pallet_flag  = :new.pallet_flag
          ,x.pallet_date  = nvl(:new.pallet_date,:old.pallet_date)
          ,x.pallet_no     = nvl(:new.pallet_no,:old.pallet_no) 
     where x.pack_barcode = :old.barcode ; 
  end if; 
  
  if :new.pallet_flag = 'N' and :old.pallet_flag = 'Y' then 
    update ip_product_pack_master 
       set pallet_flag  = :new.pallet_flag
          ,pallet_date  = null
          ,pallet_no     = null
     where pack_barcode = :old.barcode ; 
     
  end if ;
  
exception 
  when others then 
    raise_application_error(-20099,' TRG FG_INVENTORY_UPD '||substr(sqlerrm,1,150)); 
  
end TRG_ip_FG_Inventory_upd;