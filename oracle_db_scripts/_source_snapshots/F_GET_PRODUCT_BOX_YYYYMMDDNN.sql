function f_get_product_box_yyyymmddnn (
                                                          p_yyyymmdd      in  varchar2,
                                                          p_run_no        in  varchar2
                                                        )
return varchar2 is
  
  lvs_item_code   varchar2(50);
  lvs_run_no      varchar2(50);
  
  lvs_return      varchar2(50);
  lvl_count       number;
  lvl_seq         number;
  
  PRAGMA AUTONOMOUS_TRANSACTION;
  
begin
  
  -----------------------------------------------------
  -- item code와 run no 확인
  -----------------------------------------------------
  
  begin
    
      select item_code, run_no
        into lvs_item_code, lvs_run_no
        from IP_PRODUCT_RUN_CARD
       where run_no = p_run_no
         and rownum    = 1;
     
  exception
    
     when NO_DATA_FOUND then
          return 'NG 미등록 런카드'; 
          
  end ;
     
  -----------------------------------------------------
  -- 이미 생성된 run no 인지 확인
  -----------------------------------------------------
  
  select count(*), max( product_seq )
    into lvl_count, lvl_seq
    from IP_PRODUCT_BOX_YYYYMMDDNN
   where product_ymd = p_yyyymmdd
     and model_name  = lvs_item_code
     and run_no      = lvs_run_no
     and rownum      = 1;
     
  if ( lvl_count = 0 ) then
    
  -----------------------------------------------------
  -- 신규 생성
  -----------------------------------------------------  
  
       insert into ip_product_box_yyyymmddnn (
                                               product_ymd, 
                                               model_name, 
                                               run_no, 
                                               product_seq, 
                                               organization_id, 
                                               enter_date, 
                                               enter_by, 
                                               last_modify_date, 
                                               last_modify_by
                                             )
       select p_yyyymmdd,
              x.item_code, 
              x.run_no, 
              (
                select nvl(max(product_seq), 0) + 1
                  from IP_PRODUCT_BOX_YYYYMMDDNN
                 where product_ymd = p_yyyymmdd
                   and model_name  = x.item_code
                   and rownum = 1
              ),
              x.organization_id,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
         from IP_PRODUCT_RUN_CARD x
        where run_no = lvs_run_no;
        
        commit;
        
        select count(*), max( product_seq )
          into lvl_count, lvl_seq
          from IP_PRODUCT_BOX_YYYYMMDDNN
         where product_ymd = p_yyyymmdd
           and model_name  = lvs_item_code
           and run_no      = lvs_run_no
           and rownum = 1;
             
       if ( lvl_count = 1 ) then    
         
            return p_yyyymmdd||to_char( lvl_seq, 'FM00');    
         
       else
         
            return 'NG YYYYMMDDNN 생성오류';  
         
       end if;
        
 
 else
   
     return p_yyyymmdd||to_char( lvl_seq, 'FM00');
   
 end if;
    

EXCEPTION
  
  WHEN OTHERS THEN
       raise_application_error(-20003, 'NG ' || SQLERRM);
  
end;
