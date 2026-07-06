CREATE OR REPLACE PROCEDURE "P_PRODUCT_FG_ISSUE" ( p_barcode       varchar2,
  /* ================================================================
   * 프로시저명  : P_PRODUCT_FG_ISSUE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2017-08-07
   * 수정이력:
   *   2017-08-07 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   제품, 재고, 입출고 또는 팔레트 관련 업무 데이터를 등록/갱신한다.
   *   대상 데이터의 존재 여부와 수량 조건을 확인한 뒤 원본 로직에 따라 처리한다.
   *   COMMIT/ROLLBACK 포함 여부는 원본 트랜잭션 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_BAR_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_CUSTOMER_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_TXN - 원본 선언부 기준 입력/출력 파라미터
   *   P_COMMIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PDA - 원본 선언부 기준 입력/출력 파라미터
   *   PACK - 원본 선언부 기준 입력/출력 파라미터
   *   P - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATOIN - 원본 선언부 기준 입력/출력 파라미터
   *   PRODUCT - 원본 선언부 기준 입력/출력 파라미터
   *   PALLET_FLAG - 원본 선언부 기준 입력/출력 파라미터
   *   PACK_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   PALLET_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_WORKSTAGE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MACHINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_SERIAL_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_RESULT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MESSAGE - 원본 선언부 기준 입력/출력 파라미터
   *   P_NG_MESSAGE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 원본 로직 참조 테이블
   *   IP_PRODUCT_FG_INVENTORY - 원본 로직 참조 테이블
   *   IP_PRODUCT_FG_ISSUE - 원본 로직 참조 테이블
   *   IP_PRODUCT_FG_PALLET - 파렛트 작업 마스터 ( 재고테이블을 이용)
   *   IP_PRODUCT_PACK_MASTER - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_CUSTOMER_CODE_BY_MODEL
   *   F_GET_MODEL_MARKING_CONDITION
   *   F_GET_SYS_CONFIG
   *   F_GET_WORKTIME_ZONE
   *   F_GET_WORK_ACTUAL_DATE
   *   F_GET_WORK_SHIFT_CODE
   *   F_MSG
   *   P_INTERLOCK_CHECK
   *   P_LOCATOIN
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_PRODUCT_FG_ISSUE(...)
   * ================================================================ */
                                                p_bar_type      varchar2, 
                                                p_customer_code varchar2,  --출하시 필요 
                                                p_location      varchar2,  --반품시 필요 
                                                p_txn           number,    --3, 4 
                                                p_commit        varchar2, 
                                                p_out out       varchar2, 
                                                p_msg out       varchar2 ) is
                                                
   /**************************************************************************
    * 제품 출고 
    * .재고를 출하/반품 시킨다. 
    **************************************************************************  
    *    PDA / UI 동시 사용 가능  
    *    Customer Code 
    *    p_bar_type      Pallet NO 인지 개별 Pack Barcode 인지 확인 ( P - 파렛타입  
                                                                I - 개별 Pack ) 
    *    p_locatoin ( isys basecode PRODUCT LOCATION CODE ) 반품시 재고 Location 
    *    p_commit 'Y" procedure 내에서 Txn 종료 
    *             'N' 호출 UI 에서 Txn 종료 처리 
    *    p_txn  3 정상 , 4 취소 
    **************************************************************************
    * IP_PRODUCT_PACK_MASTER              RECEIPT_FLAG = 'Y' 
    *                                     SHIP_FLAG    = 'N' 
    *                                     PALLET_FLAG  = 'Y' or 'N' 
    * 
    * IP_PRODUCT_FG_INVENTORY             PALLET_FLAG = 'Y' or 'N'   
    * 
    **************************************************************************/

    
    lvl_count         number; --'I : 개별 재고 P; 파렛 단위 ' -- [AI] 내부 처리용 변수
    lvl_p01_count     number ;  --양품창고 -- [AI] 내부 처리용 변수
    lvl_p00_count     number ;  --아닌창고  -- [AI] 내부 처리용 변수
    lvl_longterm      number ;  -- [AI] 내부 처리용 변수
    
    lvs_barcode       varchar2(100); -- [AI] 내부 처리용 변수
    lvs_pallet_no     varchar2(30); -- [AI] 내부 처리용 변수
    lvs_ship_no       varchar2(24);  -- [AI] 내부 처리용 변수
    lvd_issue_date    date; -- [AI] 내부 처리용 변수
    lvl_issue_seq     number; -- [AI] 내부 처리용 변수
    lvs_ng_msg        varchar2(4000); -- [AI] 내부 처리용 변수
    lvs_ok_msg        varchar2(4000); -- [AI] 내부 처리용 변수
    
    lvl_fifo_count    number ;  -- [AI] 내부 처리용 변수
    lvs_fifo_barcode  varchar2(100) ; -- [AI] 내부 처리용 변수
    
    lvl_issue_qty     number; -- [AI] 내부 처리용 변수
    lvs_customer_code varchar2(100) ; -- [AI] 내부 처리용 변수
    
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
  
    IF ( p_customer_code is null or p_customer_code = '' ) THEN
         p_out := 'NG' ; 
         p_msg := f_msg('고객사를 입력 하세요.','C',1);
         return ;       
    END IF;

     
    /******************************
    * 바코드 확인 
    ******************************/
    begin
      
      select count(barcode), max(F_GET_CUSTOMER_CODE_BY_MODEL(model_name))
        into lvl_count, lvs_customer_code 
        from ip_product_fg_inventory x 
       where barcode            like decode(p_bar_type, 'I', p_barcode, '%')
         and nvl(pallet_no,'*') = decode(p_bar_type, 'I', '*',p_barcode )   
      ;         
           
    exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when no_data_found then
        p_out := 'NG' ; 
        p_msg := f_msg('존재하지 않는 Barcode 입니다.','C',1)||' '||p_barcode;
        return ;     
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when others then
        p_out := 'NG'; 
        p_msg := substr(sqlerrm,1,200);
        return ;   
    end ; 
    
   /***********************************
    * 출고 할 고객사가 맞는지 확인
    ***********************************/
     

           
    IF ( lvs_customer_code <> p_customer_code ) THEN
        p_out := 'NG' ; 
        p_msg := f_msg('고객사를 확인하세요.','C',1)||' => '||p_customer_code||', '||lvs_customer_code;
        return ;       
     END IF;
    
    /***********************************
    * 출하 처리 이면서 재고가 없는 것 
    ***********************************/
    if p_txn = 3 and lvl_count = 0 then 
      p_out := 'NG' ; 
      p_msg := f_msg('존재하지 않는 Barcode 입니다.','C',1)||' '||p_barcode;
      return ; 
    else 
      -----------------------------------------
      --양품 창고가 아닌 다른 창고에 존재하는 바코드는 출고 불가 
      -----------------------------------------
      select count(*) 
        into lvl_p00_count 
        from ip_product_fg_inventory x 
       where barcode            like decode(p_bar_type, 'I', p_barcode, '%')
         and nvl(pallet_no,'*') = decode(p_bar_type, 'I', '*',p_barcode )
         and location_code     <>  'P01' ; 
      
      if lvl_p00_count > 0 then 
        p_out := 'NG' ; 
        p_msg := f_msg('양품재고가 아닌 재고가 발견되었습니다. 출하 불가 입니다.','C',1)||' '||p_barcode;
        return ; 
      end if ;     
      
      -------------------------- 
      --장기재고가 포함 되어있을때 출하불가 
      --------------------------
--      select count(*) 
--        into lvl_longterm 
--        from ip_product_fg_inventory x 
--       where barcode            like decode(p_bar_type, 'I', p_barcode, '%')
--         and nvl(pallet_no,'*') = decode(p_bar_type, 'I', '*',p_barcode )
--         and ( sysdate - inventory_date ) > F_GET_SYS_CONFIG('PRODUCT_DEAD_STOCK_DAYS', 1 )   
--       ; 
--       
--      if lvl_longterm > 0 then 
--        p_out := 'NG' ; 
--        p_msg := p_barcode||' '||f_msg('장기재고가 확인이 됩니다. 출하 불가 합니다.','C',1);
--        return ; 
--      end if ;          
      
           
    end if ; 
    
    /**********************************
    * 이미 출하된 제품인지 확인
    ***********************************/    
    
    if ( p_bar_type = 'I' and  p_txn = 3 ) then
                  
            select count(*)
              into lvl_count
              from ip_product_pack_master x
             where pack_barcode = p_barcode
               and ship_flag    = 'Y' ;

            if lvl_count > 0 then
               p_out := 'NG' ;
               p_msg := f_msg('이미 출고 된 제품, 출하 불가 입니다.','C',1)||' '||p_barcode;
               return ;
            end if ; 
                      
        
    elsif ( p_bar_type = 'P' and  p_txn = 3 ) then
      
            select count(*)
              into lvl_count
              from ip_product_fg_pallet x
             where pallet_no = p_barcode
               and ship_flag = 'Y' ;

            if lvl_count > 0 then
               p_out := 'NG' ;
               p_msg := f_msg('이미 출고 된 제품, 출하 불가 입니다.','C',1)||' '||p_barcode;
               return ;
            end if ; 
      
    end if;
    
    /**********************************
    * 반품이면서 파렛을 읽을경우는 오류 
    ***********************************/
    if ((p_bar_type = 'P') and ( p_txn = 4)) then 
        p_out := 'NG' ; 
        p_msg := f_msg('파렛단위 반품처리는 불가합니다.','C',1)||' '||p_barcode;
        return ; 
    end if ;
    
    
    --정상 처리 
    if p_txn = 3 then
      
       /**************************************************
       * 정상 출하처리 
       *
       * 출고 대상을 찾는다.
       ***************************************************/  
       for c01 in ( 
         select barcode, 
                pack_type, 
                location_code, 
                qty, 
                model_name, 
                model_suffix, 
                item_code, 
                item_type, 
                nvl(pallet_no,'*') pallet_no, 
                pallet_flag, 
                pallet_date, 
                inventory_date, 
                enter_by, 
                enter_date, 
                last_modify_by, 
                last_modify_date, 
                organization_id,
                F_GET_MODEL_MARKING_CONDITION(model_name, organization_id) marking_condition
           from ip_product_fg_inventory 
          where barcode            like decode(p_bar_type, 'I', p_barcode, '%')
            and nvl(pallet_no,'*') =    decode(p_bar_type, 'I', '*',p_barcode )  
            and location_code      = 'P01' 
       ) loop
         begin 
           lvs_barcode   := c01.barcode ; 
           lvs_pallet_no := c01.pallet_no ;
           
           if p_bar_type = 'I' then 
              /******************************
              * 개별 출고 기본 확인 
              *******************************/
              if (( c01.pallet_flag = 'Y' ) or ( c01.pallet_no <> '*' ) ) then 

                 p_out := 'NG'; 
                 p_msg := f_msg( '바코드 확인 : 파렛된 바코드 입니다 개별 출고 불가합니다','C',1); 
                 
                 if p_commit = 'Y' then 
                    rollback ; 
                 end if ;
                 return ; 
              end if; 
           elsif p_bar_type = 'P' then 
              /******************************
              * 파렛출고 기본 확인 
              *******************************/
              if (( c01.pallet_flag = 'N' ) or ( c01.pallet_no = '*' ) ) then 
                
                 
                 p_out := 'NG'; 
                 p_msg := f_msg( '바코드 확인 : 일괄출고 불가한 바코드 입니다.','C',1) || ' Pallet: '||lvs_pallet_no||' Barcode: '||lvs_barcode;
                 if p_commit = 'Y' then 
                    rollback ; 
                 end if ; 
                 return ; 
              end if; 
               
           end if;
           
           
         /*************************************************************************
          * 선입선출 Logic 
          * 개별 BOX 출고품에 대한 출고시 해당모델의 선입재고 존재 유무 체크 
          * 배트남 요구로 임시 막음 유혁수 20170807
          *************************************************************************/
          if p_bar_type = 'I' and c01.marking_condition = 'N' then 
            
            begin 
              select count(*) ,  min(barcode)
                into lvl_fifo_count , lvs_fifo_barcode
                from ip_product_fg_inventory 
               where nvl(Pallet_Flag,'N')  = 'N' 
                 and model_name            = c01.model_name
                 and nvl(model_suffix,'*') = c01.model_suffix 
                 and barcode              <> c01.barcode
                 and inventory_date        < c01.inventory_date  
                 and qty > 0 
                 and location_code         = 'P01' ; 
            exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
              when others then
                p_out := 'NG'; 
                p_msg := 'CHECK FIFO'||substr(sqlerrm,1,200);
                  
                if p_commit = 'Y' then 
                    rollback ; 
                end if ; 
                return ; 
              
            end ; 
              
              
            if lvl_fifo_count > 0  then 
              p_out := 'NG' ; 
              p_msg := f_msg('FiFO : 해당재고 보다 선입재고가 존재 합니다.','C',1)||' '||to_char(lvl_fifo_count)||' rows '||lvs_fifo_barcode ;
                
              if p_commit = 'Y' then 
                    rollback ; 
              end if ; 
                
              return ;
            end if; 
            
          end if; 
           
           
          /**************************************** 
          -- 1.출고전  Interlock Check 박스단뒤 (포장단위)
          -- 05.04 추가 
          ****************************************/
          
          p_interlock_check(
                            p_line_code => '*',
                            p_workstage_code => '*',
                            p_machine_code => '*',
                            p_serial_no => c01.barcode,
                            p_type => 'FG_SHIP_CHECK',
                            p_result  => p_out,
                            p_message => p_msg,
                            p_ng_message => lvs_ok_msg,
                            p_ok_message => lvs_ng_msg
                           );                         
          
          if p_out = 'NG' then 
            p_out := 'NG';
            p_msg := p_msg||': '||lvs_ng_msg;
            
            if p_commit = 'Y' then 
                rollback ; 
            end if ; 
            
            return;
          end if ;  
         /******************************************/
           
           
           /************************************************************
           * 출고 작업 시작 
           ************************************************************/
           
           /**********************************
           * Ship No 구성 ( 쓸데는 없음 ) 
           ***********************************/
           lvs_ship_no := REPLACE(TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS@FF'),'@','I') ; 
            
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
              pallet_no, 
              ship_no, 
              pallet_date, 
              
              enter_by, 
              enter_date, 
              last_modify_by, 
              last_modify_date, 
              organization_id, 
              issue_type  
           ) values ( 
              sysdate, 
              seq_fg_issue_seq.nextval, 
              c01.barcode, 
              c01.pack_type, 
              '3',          --정상출하 
              c01.qty, 
              c01.model_name, 
              c01.model_suffix, 
              c01.item_code, 
              c01.item_type, 
              
              f_get_work_actual_date(sysdate,'A'), 
              f_get_worktime_zone(to_char(sysdate,'yyyymmdd'), to_char(sysdate,'hh24mi'),'ZONE'), 
              f_get_work_shift_code(sysdate) ,
              
              p_customer_code, 
              c01.location_code, 
              c01.pallet_no, 
              lvs_ship_no,         
              c01.pallet_date, 
              
              replace(SYS_CONTEXT('USERENV','IP_ADDRESS'),'.',''), 
              sysdate, 
              'FG_ISSUE',  
              sysdate,
              1      , 
              p_bar_type
           ) ; 
           /************************************************************
           * 재고 테이블 삭제 
           ************************************************************/
--           delete from ip_product_fg_inventory 
--           where barcode = c01.barcode ; 
           
           /************************************************************
           * Pack Master 데이터 Update
           *  
           ************************************************************/
           update ip_product_pack_master x  
              set x.ship_flag = 'Y', 
                  x.ship_date = sysdate, 
                  x.ship_no   = lvs_ship_no
            where x.pack_barcode = c01.barcode 
              and x.receipt_flag  = 'Y' ;  
            
            
           /************************************************************
           * 2D BarCode 출하 일자를 UPDATE 
           ************************************************************/
           UPDATE ip_product_2d_barcode X
              SET X.SHIPPING_DATE = SYSDATE, 
                  X.LAST_MODIFY_DATE = SYSDATE, 
                  X.LAST_MODIFY_BY   = 'SHIP_ISSUE', 
                  X.IS_PROGRESS      = '0' 
            WHERE X.SERIAL_NO IN ( 
            
                                   SELECT Z.BARCODE
                                     FROM IP_PRODUCT_PACK_MASTER Y , 
                                          IP_PRODUCT_PACK_SERIAL Z 
                                    WHERE Y.PACK_BARCODE = p_barcode
                                      AND Y.PACK_TYPE    = 'C'                --Cell Biz Type 만 M 메거진은 아님 
                                      
                                      AND Y.PACK_BARCODE = Z.PACK_BARCODE
                                 ) ; 
           
           /************************************************************/ 
            
         exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
           when others then 
             
             p_out := 'NG'; 
             p_msg := 'Loop B:'||lvs_barcode||' P: '||lvs_pallet_no||' '||substr(sqlerrm,1,200); 
             if p_commit = 'Y' then 
                rollback ; 
             end if ; 
             return ; 
         end ; 
       end loop ; 

    else
      /************************************
      * 반품처리 
      *************************************/
      
      /******************************
      * 출하 이력이 있는지 확인 
      *   가장 최근 출하 Txn 을 확인 한다. 
      *   만일 반품 이면 다시 출하 반품 불가.
      *   정상 출하이면 출하가능 
      ******************************/
      begin
        
        select txn_deficit, issue_date, issue_sequence , barcode,       qty
          into lvl_count  , lvd_issue_date, lvl_issue_seq, lvs_barcode, lvl_issue_qty
          from ip_product_fg_issue x 
         where x.barcode            = p_barcode 
           and x.issue_date = ( 
                                  select max(y.issue_date) 
                                    from ip_product_fg_issue y 
                                   where y.barcode = p_barcode 
                               )  ; 
             
      exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        when no_data_found then
          p_out := 'NG' ; 
          p_msg := f_msg('출하 정보가 존재 하지 않는 Barcode 입니다.','C',1);
          return ;     
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        when others then
          p_out := 'NG'; 
          p_msg := substr(sqlerrm,1,200);
          return ;   
      end ; 
      
      /*************************
      * txn deficit 3 정상 출하 4 반품 
      * 
      *************************/
      if lvl_count = 4 then 
        p_out := 'NG'; 
        p_msg := f_msg( '최근에 출하 반품된 Barcode 입니다.','C',1); 
        return ; 
               
      end if;  
      
      /**********************************
      * Ship No 구성 ( 쓸데는 없음 ) 
      ***********************************/
      lvs_ship_no := REPLACE(TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS@FF'),'@','I') ; 
      
      /**************************
      * 출하 반품 시작 
      ***************************/
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
              
              barcode,
              pack_type,
              '4',            --출하반품 
              
              qty, 
              model_name, 
              model_suffix, 
              item_code, 
              item_type, 
              
              f_get_work_actual_date(sysdate,'A'), 
              f_get_worktime_zone(to_char(sysdate,'yyyymmdd'), to_char(sysdate,'hh24mi'),'ZONE'), 
              f_get_work_shift_code(sysdate) ,
              
              customer_code, 
              
              p_location, 
              
              lvs_ship_no, 
     
              replace(SYS_CONTEXT('USERENV','IP_ADDRESS'),'.',''), 
              sysdate, 
              'FG_ISSUE4',  
              sysdate,
              1      , 
              'I'         --P 파렛 I 개별 포장 출하 
         from ip_product_fg_issue
        where issue_date     = lvd_issue_date
          and issue_sequence = lvl_issue_seq ;
          
      /**************************************
      * fg inventory 살리기 
      ***************************************/
         
       
      if ( p_bar_type = 'P' ) THEN
                         
           update ip_product_fg_inventory
              set qty       = lvl_issue_qty

            where barcode   = lvs_barcode
              and pallet_no = lvs_pallet_no;  
              
      elsif ( p_bar_type = 'I' ) THEN
        
           update ip_product_fg_inventory
              set qty       = lvl_issue_qty
            where barcode   = lvs_barcode;        
                
      end if; 
      
     /* 
               
      insert into ip_product_fg_inventory ( 
        barcode, 
        pack_type, 
        location_code, 
        qty, 
        model_name, 
        model_suffix, 
        item_code, 
        item_type, 
        
        inventory_date, 
        
        enter_by, 
        enter_date, 
        last_modify_by, 
        last_modify_date, 
        organization_id, 
        
        receipt_no

      ) 
      select barcode, 
             pack_type, 
             p_location , 
             qty,
             model_name, 
             model_suffix, 
             item_code,
             item_type, 
             
             sysdate,
             
             replace(SYS_CONTEXT('USERENV','IP_ADDRESS'),'.',''), 
             sysdate, 
             'FG_ISSUE4',  
             sysdate,
             1      ,
              
             lvs_ship_no
              
        from ip_product_fg_issue
       where issue_date     = lvd_issue_date
         and issue_sequence = lvl_issue_seq ; 

*/
      
      /**************************************
      * pack master 돌리기 
      * 파렛으로 출고가 되도 반품시에는 박스단위 임  
      ***************************************/
      update ip_product_pack_master x 
         set x.ship_flag = 'N' , 
             x.ship_no   = lvs_ship_no, 
             x.ship_date = null,
             
             x.pallet_flag = 'N', 
             x.pallet_no   = null, 
             x.pallet_date = null, 
             
             x.last_modify_date = sysdate,
             x.last_modify_by   = 'FG_ISSUE4',
             x.ATTR8            = 'R'
       where x.pack_barcode     = p_barcode ; 
       
       
       /************************************************************
       * 2D BarCode 출하 일자를 UPDATE 
       ************************************************************/
       UPDATE ip_product_2d_barcode X
          SET X.SHIPPING_DATE    = NULL  , 
              X.LAST_MODIFY_DATE = SYSDATE, 
              X.LAST_MODIFY_BY   = 'SHIP_RETURN', 
              X.PALLETE_NO       = NULL , 
              X.IS_PROGRESS      = '1'
        WHERE X.SERIAL_NO IN ( 
            
                               SELECT Z.BARCODE
                                 FROM IP_PRODUCT_PACK_MASTER Y , 
                                      IP_PRODUCT_PACK_SERIAL Z 
                                WHERE Y.PACK_BARCODE = p_barcode
                                  AND Y.PACK_TYPE    = 'C'                --Cell Biz Type 만 M 메거진은 아님 
                                      
                                  AND Y.PACK_BARCODE = Z.PACK_BARCODE
                             ) ; 
           
       /************************************************************/ 
       
    
    end if ; 
    
    
    if p_commit = 'Y' then 
       commit ; 
    end if;
    
    p_out := 'OK'; 
    
    if p_txn = 3 then 
      if p_bar_type = 'I' then 
         p_msg := 'Issue '||' '||f_msg('정상처리 되었습니다.','C',1)||' '||p_barcode;
      elsif p_bar_type = 'P' then 
         p_msg := 'Pallet Issue '||' '||f_msg('정상처리 되었습니다.','C',1)||' '||p_barcode;
      end if ; 
    else 
       p_msg := 'Issue Cancel '||' '||f_msg('정상처리 되었습니다.','C',1)||' '||p_barcode;
    end if;
    
exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then 
    p_out := 'NG' ; 
    p_msg := substr(sqlerrm,1,200); 
    
    if p_commit = 'Y' then 
      rollback ; 
    end if; 
      
end P_PRODUCT_FG_ISSUE;
