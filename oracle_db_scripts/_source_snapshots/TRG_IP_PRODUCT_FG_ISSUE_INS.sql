TRIGGER "TRG_IP_PRODUCT_FG_ISSUE_INS"
  before insert on ip_product_fg_issue 
  for each row

declare

  /**********************************************
  * 모델단위 입고 시 재고 생성
  ***********************************************/     
   lvs_error_msg      varchar2(500); 
   lvl_count          number;
  
   lvs_txn_deficit    varchar2(10); 
   lvs_location_code  varchar2(10); 
   lvl_qty            number;  
   
   lvs_step           varchar2(200); 
   
   lvl_last_seq       number;
  
begin
  

 /*****************************************
  * 2.정상입고 
  *****************************************/
  if :new.txn_deficit = '3' then   
      
     select count(*) 
       into lvl_count
       from ip_product_fg_inventory     
      where barcode       = :new.barcode
        and location_code = :new.location_code;
      
      if lvl_count = 0  then
        
         lvs_error_msg := '출고 할 재고가 없습니다';
         p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(lvs_error_msg,1,200),'TRG') ; 
         raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));
          
      else
     
          update ip_product_fg_inventory
             set qty           = qty - :new.qty
           where barcode       = :new.barcode
             and location_code = :new.location_code;
        
      end if;
        
   elsif :new.txn_deficit = '4' then  
     
     -- 출고이력 확인
     begin
      
         select qty
           into lvl_qty
           from ip_product_fg_inventory     
          where barcode       = :new.barcode
            and location_code = :new.location_code;
          
         if ( lvl_qty <> 0 ) then
                              
              lvs_error_msg := '출고 취소 할 재고가 0이 아닙니다';    -- 출고취소시 재고는 0 이이어야 함
              p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(lvs_error_msg,1,200),'TRG') ; 
              raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));
                                                   
         else
                                                      
              update ip_product_fg_inventory
                 set qty            = qty + :new.qty
               where barcode        = :new.barcode
                 and location_code  = :new.location_code;    
                               
         end if; 
         
     exception 
         when no_data_found then 
           
              lvs_error_msg := '지정한 로케이션에 재고정보가 없습니다';
              p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(lvs_error_msg,1,200),'TRG') ; 
              raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));   
              
         when others then 
           
              lvs_error_msg := substr(sqlerrm,1,150); 
              p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(lvs_error_msg,1,200),'TRG') ; 
              raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));                
           
     end;  
     
      
   end if;

exception 
  when others then 
       p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(sqlerrm,1,200),'TRG') ; 
       raise_application_error(-20099,'TRG NG : '||substr(sqlerrm,1,150)); 

end TRG_IP_PRODUCT_FG_ISSUE_INS;
