PROCEDURE "P_PRODUCT_FG_ACTUAL_RECEIPT" (
                                                            p_barcode in varchar2,
                                                            p_qty     in number,
                                                            p_commit  in varchar2,
                                                            p_out     out varchar2,
                                                            p_msg     out varchar2
                                                            ) is
   /****************************************************
    * 실적발생시 모델단위 자동입고 
    ****************************************************/
    lvl_count number;
    
begin
    

    /******************************
    * Pack 수량 없는건은 입고 안됨
    ******************************/
     select count(*) 
       into lvl_count
       from ip_product_fg_inventory     
      where barcode   = p_barcode;
      
     if lvl_count = 0  then
        
          /*****************************************
          * 재고 테이블에 입력  
          *****************************************/
          
          insert into ip_product_fg_inventory ( 
                barcode , 
                pack_type, 
                location_code, 
                qty, 
                
                model_name, 
                model_suffix, 
                item_code, 
                item_type, 
                pallet_flag, 
                inventory_date, 
                
                enter_by, 
                enter_date, 
                last_modify_by, 
                last_modify_date, 
                organization_id
          ) 
		       select p_barcode, 
                  'G', 
                  'P01', 
                  p_qty,
               
                  model_name, 
                  model_suffix, 
                  item_code, 
                  '*',            
                  'N',                    
                  sysdate,            
                           
                 'FG_RECV_TRG',
                  sysdate,
                  'FG_RECV_TRG',
                  sysdate,
                  organization_id  
          from ip_product_model_master
		     where model_name = p_barcode
		       and rownum     = 1;
           
      else
     
          update ip_product_fg_inventory
             set qty = qty + p_qty
           where barcode = p_barcode;
        
      end if;  
      
      p_out := 'OK' ;
      p_msg :=  '';
      
      if p_commit = 'Y' then
         commit;
      end if;

exception
  when others then
    
    p_out := 'NG' ;
    p_msg := substr(sqlerrm,1,200);
    
    if p_commit = 'Y' then
         rollback;
    end if;    

end P_PRODUCT_FG_ACTUAL_RECEIPT;
