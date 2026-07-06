PROCEDURE "P_PRODUCT_FG_INV_MOVE" (p_barcode varchar2,
                                                  p_location varchar2,  
                                                  p_commit varchar2, 
                                                  p_out out varchar2, 
                                                  p_msg out varchar2) is

/*******************************************************
* 재고 이동 p_location : to Location 
********************************************************/
  lvs_c_location varchar2(20); 
  lvd_inv_date   date ; 
  lvs_pack_type  varchar2(20); 
  
  lvs_out        varchar2(4000);
  lvs_msg        varchar2(4000); 
  
begin
  /*******************
  * 창고에 존재하는지 여부 확인 
  ********************/
  begin 
    select x.location_code , 
           x.inventory_date, 
           x.pack_type 
      into lvs_c_location, 
           lvd_inv_date  , 
           lvs_pack_type
      from ip_product_fg_inventory x 
     where x.barcode = p_barcode ; 
  exception 
     when no_data_found then
        p_out := 'NG' ; 
        p_msg := f_msg('존재하지 않는 Barcode 입니다.','C',1);
        return ;     
      when others then
        p_out := 'NG'; 
        p_msg := substr(sqlerrm,1,200);
        return ;      
  end ;
  
  if lvs_c_location = p_location then 
     p_out := 'NG' ; 
     p_msg := f_msg('이동할 창고와 현창위치가 동일 합니다.','C',1);
     return ;   
  end if ; 
  
  
  /****************************
  * 1. 입고 반품 실시 
  *****************************/
  if lvs_pack_type = 'C' then 
  --   p_product_fg_receipt(p_barcode,'*','2','N', lvs_out, lvs_msg ) ; 
     p_product_fg_receipt(p_barcode,lvs_c_location,'2','N', lvs_out, lvs_msg ) ; 
  else 
--  p_product_fg_magazine_receipt(p_barcode,'*','2','N', lvs_out, lvs_msg ) ;     
     p_product_fg_magazine_receipt(p_barcode,lvs_c_location,'2','N', lvs_out, lvs_msg ) ; 
  end if ;
  
  if lvs_out = 'NG' then 
    p_out := 'NG' ; 
    p_msg := f_msg('재고이동 반품','C',1)||'  '||lvs_msg ;
    rollback ; 
    return ;     
  end if; 
  
  /****************************
  * 2. 입고 실시 
  *****************************/
  if lvs_pack_type = 'C' then 
     p_product_fg_receipt(p_barcode,p_location,'1','N', lvs_out, lvs_msg ) ; 
  else
     p_product_fg_magazine_receipt(p_barcode,p_location,'1','N', lvs_out, lvs_msg ) ; 
  end if; 
  
  if lvs_out = 'NG' then 
    p_out := 'NG' ; 
    p_msg := f_msg('재고이동 입고','C',1)||'  '||p_barcode||' '||lvs_msg ;
    rollback ; 
    return ;     
  end if; 
  
  p_out := 'OK' ; 
  p_msg := 'Inventory Move Success' ; 
  commit ; 
  
  begin 
    update ip_product_fg_inventory x 
       set x.inventory_date = lvd_inv_date 
     where barcode          = p_barcode ;
     
     commit ;  
  exception 
    when others then 
      rollback ; 
      return ; 
  end ; 
    
end P_PRODUCT_FG_INV_MOVE;
