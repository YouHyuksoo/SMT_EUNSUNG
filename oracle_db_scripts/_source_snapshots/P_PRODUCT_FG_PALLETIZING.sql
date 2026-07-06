PROCEDURE "P_PRODUCT_FG_PALLETIZING" (p_pallet  varchar2,
                                                     p_barcode varchar2, --재고테이블의 Pack Barcode   
                                                     p_txn     varchar2, --Type L 정상 , U 취소  
                                                     p_mix     varchar2 default 'Y',  
                                                     p_commit  varchar2, 
                                                     p_out out varchar2, 
                                                     p_msg out varchar2) is
   /****************************************************
    * 파렛팅 
    * 재고를 출하하기 위하여 파렛 적재 한다.
    ****************************************************
    *    PDA / UI 동시 사용 가능  
    *    p_txn     L 정상 , U 취소
    *    p_pallet  적재할 Pallet No 
    *    p_barcode 재고 테이블에 입고 되어있고, 파렛되지 않고, 출하 되지 않은 재고 바코드 
    *    p_mix     모델 혼용 할 것인지 
    *    p_commit  프로시저에서 Transaction 수행 완료 할 것 인지 
    *    p_out     NG or OK 
    *    p_msg     메시지   
    ****************************************************
    * IP_PRODUCT_FG_INVENTORY = 'N' 인것 
    ****************************************************/
    lvs_receipt_flag varchar2(1) ; 
    lvs_pallet_flag  varchar2(1) ;
    
    lvl_stock_qty     number      ; 
    lvs_model_name   varchar2(30); 
    lvs_model_suffix varchar2(30);
    
    lvs_pallet_status varchar2(1);
    lvs_ship_flag     varchar2(1) ; 
    lvs_p_model       varchar2(30); 
    lvs_p_suffix      varchar2(30); 
    
    lvs_stock_pallet  varchar2(30);
    
    lvs_ok_msg        varchar2(4000);
    lvs_ng_msg        varchar2(4000);
    
    lvd_inv_date      date ; 
    lvl_fifo_count    number ; 
     
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
        p_msg := f_msg('존재하지 않는 Pallet 입니다.','C',1);
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
    
    if lvs_pallet_status = 'C' then 
        p_out := 'NG' ; 
        p_msg := f_msg('이미 파렛적재 완료 상태입니다','C',1)||' '||p_pallet ;
        return ;
    end if;
    
    
    /******************************
    * 파렛 가능한 재고인지 바코드 확인 
    ******************************/
    begin 
      select x.model_name,  x.model_suffix  , x.qty        ,  x.pallet_flag,   nvl(x.pallet_no,'*') as pallet_no , x.inventory_date
        into lvs_model_name,lvs_model_suffix, lvl_stock_qty,  lvs_pallet_flag, lvs_stock_pallet, lvd_inv_date 
        from ip_product_fg_inventory x 
       where barcode                   = p_barcode ; 
    exception 
      when no_data_found then
        p_out := 'NG' ; 
        p_msg := f_msg('존재하지 않는 Barcode 입니다.','C',1)||' '||p_barcode;
        return ;     
      when others then
        p_out := 'NG'; 
        p_msg := substr(sqlerrm,1,200);
        return ;   
    end ; 

      
    if lvs_pallet_flag = 'Y' then 
      if p_txn = 'L' then 
        p_out := 'NG' ; 
        p_msg := f_msg('이미 파렛 구성이 완료된 재고 입니다.','C',1)||' '||p_barcode ;
        return ;
      elsif p_txn = 'U' then
        
        if lvs_stock_pallet <> p_pallet then
          p_out := 'NG' ; 
          p_msg := f_msg('해당 바코드는 다른 파렛에 존재하는 파렛재고 입니다.','C',1)||' '||lvs_stock_pallet||' '||p_pallet ;
          return ;
        end if;  
        
      end if;
      
    elsif lvs_pallet_flag = 'N' and p_txn = 'U' then 
      p_out := 'NG' ; 
      p_msg := f_msg('취소불가 : 해당 바코드는 파렛구성되지 않은 재고입니다. .','C',1)||' '||lvs_stock_pallet||' '||p_pallet ;
      return ;
      
    end if;
    
    
    
    /*************************************************************************
    * 선입선출 Logic 
    * Pallet Loading 시 해당모델의 선입재고 존재 유무 체크 
    *************************************************************************/
    begin 
      select count(*) 
        into lvl_fifo_count
        from ip_product_fg_inventory 
       where nvl(Pallet_Flag,'N')  = 'N' 
         and model_name            = lvs_model_name
         and nvl(model_suffix,'*') = lvs_model_suffix 
         and barcode              <> p_barcode
         and inventory_date        < lvd_inv_date 
         and location_code         = 'P01'   --양품창고  
          ; 
    exception 
      when others then
        p_out := 'NG'; 
        p_msg := 'CHECK FIFO'||substr(sqlerrm,1,200);
        return ; 
    
    end ; 
    
-- 임시로 막음 20170804 YHS
--    if lvl_fifo_count > 0 and p_txn = 'L' then 
--      p_out := 'NG' ; 
--      p_msg := f_msg('FiFO : 해당재고 보다 선입재고가 존재 합니다.','C',1)||' '||to_char(lvl_fifo_count)||' rows ' ;
--      return ;
--    end if; 
    
    
  
    /********************************
    * 모델 Mix Check 
    *********************************/
    if p_mix = 'Y' then 
      --혼적 
      null ; 
    elsif p_mix = 'N' then 
      --단일모델 
      if lvs_p_model <> lvs_model_name then 
          p_out := 'NG' ; 
          p_msg := f_msg('모델 혼적입니다. 허용되지 않는 작업입니다.','C',1)||' P: '||lvs_p_model||' I: '||lvs_model_name ;
          return ;
      end if;
    end if;
    
    /****************************************
    * 파렛 구성 시작 L - Loading , U - Unloading 
    * U : 해당 Pallet 에서 해당 재고를 빼낸다. 
    ****************************************/

    --정상 처리 로딩 
    if p_txn = 'L' then
          
         
--          /*********************************/
--          -- 1.Pallet 전  Interlock Check 박스단뒤 (포장단위)
--          -- 05.04 추가 
--          p_interlock_check(p_line_code => '*',
--                            p_workstage_code => '*',
--                            p_machine_code => '*',
--                            p_serial_no => p_barcode ,
--                            p_type    => 'FG_PALLET_CHECK',
--                            p_result  => p_out,
--                            p_message => p_msg,
--                            p_ng_messgae => lvs_ok_msg,
--                            p_ok_message => lvs_ng_msg);
--          
--          if p_out = 'NG' then 
--            p_msg := p_msg||' : '||lvs_ng_msg;
--            return;
--          end if ;  
          /*********************************/
 
    
          /***********************
          ip_product_pack_master x  pack master 에는 Trigger 로 처리 합시다. 
          pallet no, pallet Flag , pallet da 
          ************************/
          update ip_product_fg_inventory  x
             set x.pallet_no      = p_pallet
                ,x.pallet_flag    = 'Y' 
                ,x.pallet_date    = sysdate
                ,x.last_modify_by = sys_context('userenv','IP_ADDRESS')
      
           where x.barcode        = p_barcode ; 
          
          /**************************
          * 파렛수량 UPDATE  
          ***************************/ 
          update ip_product_fg_pallet x  
             set x.pallet_qty = nvl(x.pallet_qty,0) +  lvl_stock_qty
                ,x.pallet_type = decode(p_mix,'Y','M','S')
           where x.pallet_no  = p_pallet ; 
           
           
           --============================================
          -- 팔레틑 번호
          --============================================
          UPDATE IP_PRODUCT_2D_BARCODE SET pallete_no = p_pallet
           WHERE  BOX_NO = p_barcode ;          
           
           
          /**************************
          * Pack Master Update Trigger
          ***************************/
          update ip_product_pack_master x
             set x.pallet_flag  = 'Y'
                ,x.pallet_no     = p_pallet
                ,x.pallet_date  = sysdate 
           where x.pack_barcode = p_barcode ;
           
           
         if p_commit = 'Y' then 
           commit ; 
         end if;   
    --취소 처리 
    else
          /***********************
          ip_product_pack_master x  pack master 에는 Trigger 로 처리 합시다. 
          pallet no, pallet Flag , pallet da 
          ************************/
          update ip_product_fg_inventory  x
             set x.pallet_no      = NULL
                ,x.pallet_flag    = 'N' 
                ,x.pallet_date    = NULL
                ,x.last_modify_by = sys_context('userenv','IP_ADDRESS')
           where x.barcode        = p_barcode ; 
          
          /**************************
          * 파렛수량 UPDATE  
          ***************************/ 
          update ip_product_fg_pallet x  
             set x.pallet_qty = nvl(x.pallet_qty,0) -  lvl_stock_qty
           where x.pallet_no  = p_pallet ; 
           
          --============================================
          -- 팔레틑 번호취소 
          --============================================
          UPDATE IP_PRODUCT_2D_BARCODE SET pallete_no = null
           WHERE box_no = p_barcode ; 
    
          /**************************
          * Pack Master Update TRigger
          ***************************/
          update ip_product_pack_master x
             set x.pallet_flag  = 'N'
                ,x.pallet_no    = NULL
                ,x.pallet_date  = NULL 
           where x.pack_barcode = p_barcode ; 
           
           
         if p_commit = 'Y' then 
           commit ; 
         end if;   

    end if ; 
    
    p_out := 'OK'; 
    
    if p_txn = 'U' then 
       p_msg := p_pallet||', '||p_barcode||' '||to_char(lvl_stock_qty)||'  '||' Load Pallet '||' '||f_msg('정상처리 되었습니다.','C',1);
    else 
       p_msg := p_pallet||', '||p_barcode||' '||to_char(lvl_stock_qty)||'  '||' Unload Pallet  '||' '||f_msg('정상처리 되었습니다.','C',1);
    end if;
    
exception 
  when others then 
    p_out := 'NG' ; 
    p_msg := substr(sqlerrm,1,200); 
    
    if p_commit = 'Y' then 
      rollback ; 
    end if; 
      
end P_PRODUCT_FG_PALLETIZING;
