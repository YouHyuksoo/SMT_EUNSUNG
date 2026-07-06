PROCEDURE "P_PRODUCT_FG_PALLET_UNLOAD" (p_pallet  varchar2,
                                                       p_commit  varchar2, 
                                                       p_out out varchar2, 
                                                       p_msg out varchar2) is
   /****************************************************
    * 파렛팅 
    * 재고를 출하하기 위하여 파렛 적재 한다.
    ****************************************************
    *    PDA / UI 동시 사용 가능  
    *    p_commit  프로시저에서 Transaction 수행 완료 할 것 인지 
    *    p_out     NG or OK 
    *    p_msg     메시지   
    ****************************************************
    * IP_PRODUCT_FG_INVENTORY = 'N' 인것 
    ****************************************************/
   
    lvs_pallet_status varchar2(1);
    lvs_ship_flag     varchar2(1) ; 
    lvs_p_model       varchar2(30); 
    lvs_p_suffix      varchar2(30); 
    
    
begin
    /******************************
    * 파렛 정보 확인  
    ******************************/
    begin 
      select x.pallet_status, x.ship_flag, x.model_name, x.model_suffix
        into lvs_pallet_status, lvs_ship_flag, lvs_p_model, lvs_p_suffix 
        from ip_product_fg_pallet x
       where x.pallet_no = p_pallet ; 
    exception
      when no_data_found then 
        p_out := 'NG' ; 
        p_msg := f_msg('존재하지 않는 Pallet 입니다.','C',1)||' '||p_pallet ;
        return ;     
      when others then
        p_out := 'NG'; 
        p_msg := substr(sqlerrm,1,200);
        return ;   
    end ; 
    
    if lvs_ship_flag = 'Y' then 
        p_out := 'NG' ; 
        p_msg := f_msg('이미 출하 완료 되었습니다','C',1)||' '||p_pallet ;
        return ;
    end if;
    
    if lvs_pallet_status = 'P' then
       --'C' 완료  
        p_out := 'NG' ; 
        p_msg := f_msg('파렛 적재 진행중입니다.','C',1)||' '||p_pallet ;
        return ;
    end if;
    
    
   
    /***********************
    파렛 해체 
    ************************/
    update ip_product_fg_inventory  x
       set x.pallet_no      = NULL
          ,x.pallet_flag    = 'N' 
          ,x.pallet_date    = NULL
          ,x.last_modify_by = sys_context('userenv','IP_ADDRESS')
     where x.pallet_no      = p_pallet ; 
          
    /**************************
    * 파렛 삭제 
    ***************************/ 
    delete ip_product_fg_pallet x  
     where x.pallet_no  = p_pallet ; 
           
    /**************************
    * Pack Master Update TRigger
    ***************************/
    update ip_product_pack_master x
       set x.pallet_flag  = 'N'
          ,x.pallet_no    = NULL
          ,x.pallet_date  = NULL 
     where x.Pallet_No    = p_pallet ; 
     
    /*2D 바코드*/   
    UPDATE IP_PRODUCT_2D_BARCODE 
       SET pallete_no = NULL
     WHERE pallete_no = p_pallet ;
                    
   if p_commit = 'Y' then 
     commit ; 
   end if;   


    
    p_out := 'OK'; 
    p_msg := p_pallet||', '||'Pallet'||' '||f_msg('정상삭제 되었습니다.','C',1);
    
    
exception 
  when others then 
    p_out := 'NG' ; 
    p_msg := substr(sqlerrm,1,200); 
    
    if p_commit = 'Y' then 
      rollback ; 
    end if; 
      
end P_PRODUCT_FG_PALLET_UNLOAD;
