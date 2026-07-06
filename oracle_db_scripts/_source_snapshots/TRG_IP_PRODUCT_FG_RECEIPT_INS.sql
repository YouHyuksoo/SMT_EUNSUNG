TRIGGER "TRG_IP_PRODUCT_FG_RECEIPT_INS"
  before insert on ip_product_fg_receipt  
  for each row

declare

  /**********************************************
  * 모델단위 입고 시 재고 생성
  ***********************************************/     
   lvs_error_msg        varchar2(200); 
   lvl_count            number;
  
   lvs_txn_deficit      varchar2(10);     
   lvs_location_code    varchar2(10);
   lvl_qty              number;
   
begin
  
 /*****************************************
  * 2.정상입고 
  *****************************************/
  if :new.txn_deficit = '1' then   
    
     select count(*) 
       into lvl_count
       from ip_product_fg_inventory     
      where barcode   = :new.barcode
        and location_code = :new.location_code;
      
      if lvl_count = 0  then
        
          /*****************************************
          * 2-1.재고 테이블에 입력  
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
                --pallet_no, 
                pallet_flag, 
                --pallet_date, 
                inventory_date, 
                
                enter_by, 
                enter_date, 
                last_modify_by, 
                last_modify_date, 
                organization_id

          ) values ( 
               :new.barcode, 
               :new.pack_type, 
               :new.location_code, 
               :new.qty,
               
               :new.model_name, 
               :new.model_suffix, 
               :new.item_code, 
               :new.item_type,
               
               'N',                --Pallet flag 
               sysdate,            --재고 생성 일자 ( 장기 재고등을 확인시 ) 
                           
               'FG_RECV_TRG',
               sysdate,
               'FG_RECV_TRG',
               sysdate,
               :new.organization_id  
          ) ; 
          
      else
     
          update ip_product_fg_inventory
             set qty            = qty + :new.qty,
                 inventory_date = sysdate
           where barcode        = :new.barcode
             and location_code  = :new.location_code;
        
      end if;
        
   elsif :new.txn_deficit = '2' then 
     
     -- 입고이력 확인
     begin
      
         select qty
           into lvl_qty
           from ip_product_fg_inventory     
          where barcode       = :new.barcode
            and location_code = :new.location_code;
                
                                   
         if ( lvl_qty <= 0 ) then
                                  
              lvs_error_msg := '입고 취소 할 재고가 0 보다 크지 않습니다'; -- 입고취소시 재고는 0 보다ㅏ 크야 함 
              p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(lvs_error_msg,1,200),'TRG') ; 
              raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));
                                                       
         else
                                                      
              update ip_product_fg_inventory
                 set qty           = qty - :new.qty
               where barcode       = :new.barcode
                 and location_code = :new.location_code;   
                                       
         end if;  
         
     exception 
         when no_data_found then 
           
              lvs_error_msg := '지정한 로케이션에 재고정보가 없습니다';
              p_job_errorlog(920,1,'제품입고 TRG','TRG_IP_PRODUCT_FG_RECEIPT_INS',substr(lvs_error_msg,1,200),'TRG') ; 
              raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));   
              
         when others then 
           
              lvs_error_msg := substr(sqlerrm,1,150); 
              p_job_errorlog(920,1,'제품입고 TRG','TRG_IP_PRODUCT_FG_RECEIPT_INS',substr(lvs_error_msg,1,200),'TRG') ; 
              raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));                
           
     end;         
         
      
  end if; 

exception 
  when others then 
       p_job_errorlog(920,1,'제품입고 TRG','TRG_IP_PRODUCT_FG_RECEIPT_INS',substr(sqlerrm,1,200),'TRG') ; 
       raise_application_error(-20099,'TRG NG : '||substr(sqlerrm,1,150)); 

end TRG_IP_PRODUCT_FG_RECEIPT_INS;
