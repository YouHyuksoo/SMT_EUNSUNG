PROCEDURE "P_PRODUCT_FG_MODEL_ISSUE" ( p_barcode       varchar2,
                                                         p_qty           varchar2, 
                                                         p_location      varchar2,  --반품시 필요 
                                                         p_txn           number,    --3, 4 
                                                         p_commit        varchar2, 
                                                         p_out out       varchar2, 
                                                         p_msg out       varchar2 ) is
   /**************************************************************************
    * MODEL 단위 제품 출고 
    *    PDA / UI 동시 사용 가능
    *    p_locatoin ( isys basecode PRODUCT LOCATION CODE )
    *    p_commit 'Y" procedure 내에서 Txn 종료
    *             'N' 호출 UI 에서 Txn 종료 처리
    *    p_txn  1 정상 , 2 취소
    **************************************************************************/
    
    lvl_count      number; --'I : 개별 재고 P; 파렛 단위 '
    lvl_p01_count  number ;  --양품창고
    lvl_p00_count  number ;  --아닌창고 
    lvl_longterm   number ; 
    lvs_barcode    varchar2(30);
    lvs_pallet_no  varchar2(30);
    lvs_ship_no    varchar2(24); 
    lvd_issue_date date;
    lvl_issue_seq  number;
    lvs_ng_msg     varchar2(4000);
    lvs_ok_msg     varchar2(4000);
    
    lvl_fifo_count   number ; 
    
    lvs_pack_type    varchar2(2);
    lvl_pack_qty     number     ;
    lvs_model_name   varchar2(50);
    lvs_item_code    varchar2(50);
    
    lvl_count        number ;
    
begin
  
   /******************************
    * 바코드 확인
    ******************************/
    
    begin
      
      select model_name, item_code, to_number( p_qty ), 'G'
        into lvs_model_name, lvs_item_code, lvl_pack_qty, lvs_pack_type
        from ip_product_fg_inventory
       where barcode    = p_barcode 
         and rownum     = 1;
       
    exception
      when no_data_found then
           p_out := 'NG' ;
           p_msg := f_msg('존재하지 않는 재고 입니다.','C',1);
           return ;
      when others then
           p_out := 'NG';
           p_msg := substr(sqlerrm,1,200);
           return ;
    end ;

    /******************************
    * Pack 수량 없는건은 입고 안됨
    ******************************/
    if lvl_pack_qty < 1 then
       p_out := 'NG' ;
       p_msg := f_msg('출고 할 수량을 확인하세요.','C',1);
       return ;
    end if ;

    -- 처리
     
      insert into ip_product_fg_issue ( 
                                       issue_date, 
                                       issue_sequence, 
              
                                       barcode, 
                                       pack_type, 
                                       txn_deficit, 
            
                                       qty, 
                                       model_name, 
                                       model_suffix, 
                                       item_code, 
                                       item_type, 
              
                                       actual_date, 
              
                                       work_time_zone, 
                                       shift_code, 
              
                                       customer_code, 
                                       --sales_unit_price, 
                                       --currency, 
                                       --mfs, 
                                       --line_code, 
                                       --workstage_code, 
                                       --machine_code, 
              
                                       location_code, 
 
                                       ship_no, 
         
                                       enter_by, 
                                       enter_date, 
                                       last_modify_by, 
                                       last_modify_date, 
                                       organization_id, 
                                       issue_type 
                                ) 
       select sysdate,
              seq_fg_issue_seq.nextval, 
              
              p_barcode,
              lvs_pack_type,
              p_txn,            --출하반품 
              
              lvl_pack_qty, 
              lvs_model_name, 
              '*', 
              lvs_item_code, 
              '*', 
              
              f_get_work_actual_date(sysdate,'A'), 
              f_get_worktime_zone(to_char(sysdate,'yyyymmdd'), to_char(sysdate,'hh24mi'),'ZONE'), 
              f_get_work_shift_code(sysdate) ,
              
              '*', 
              
              p_location, 
              
              '*', 
     
              replace(SYS_CONTEXT('USERENV','IP_ADDRESS'),'.',''), 
              sysdate, 
              'FG_ISSUE4',  
              sysdate,
              1      , 
              '*'         --P 파렛 I 개별 포장 출하 
          from dual;
             
    
    if p_commit = 'Y' then 
       commit ; 
    end if;
    
    p_out := 'OK'; 
    
    if p_txn = 3 then 
       p_msg := p_barcode||', Issue '||' '||f_msg('정상처리 되었습니다.','C',1); 
    else 
       p_msg := p_barcode||', Issue Cancel '||' '||f_msg('정상처리 되었습니다.','C',1);
    end if;
    
exception 
  when others then 
    p_out := 'NG' ; 
    p_msg := substr(sqlerrm,1,200); 
    
    if p_commit = 'Y' then 
      rollback ; 
    end if; 
      
end P_PRODUCT_FG_MODEL_ISSUE;
