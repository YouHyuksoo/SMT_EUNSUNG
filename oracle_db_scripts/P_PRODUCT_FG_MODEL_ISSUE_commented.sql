CREATE OR REPLACE PROCEDURE "P_PRODUCT_FG_MODEL_ISSUE" ( p_barcode       varchar2,
  /* ================================================================
   * 프로시저명  : P_PRODUCT_FG_MODEL_ISSUE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   제품, 재고, 입출고 관련 업무 데이터를 등록 또는 갱신한다.
   *   대상 데이터의 존재 여부와 수량 조건을 확인한 뒤 원본 로직에 따라 처리한다.
   *   COMMIT/ROLLBACK 포함 여부는 원본 트랜잭션 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_TXN - 원본 선언부 기준 입력/출력 파라미터
   *   P_COMMIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PDA - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATOIN - 원본 선언부 기준 입력/출력 파라미터
   *   PRODUCT - 원본 선언부 기준 입력/출력 파라미터
   *   PACK - 원본 선언부 기준 입력/출력 파라미터
   *   P - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_FG_INVENTORY - 원본 로직 참조 테이블
   *   IP_PRODUCT_FG_ISSUE - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKTIME_ZONE
   *   F_GET_WORK_ACTUAL_DATE
   *   F_GET_WORK_SHIFT_CODE
   *   F_MSG
   *   P_LOCATOIN
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_PRODUCT_FG_MODEL_ISSUE(...)
   * ================================================================ */
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
    
    lvl_count      number; --'I : 개별 재고 P; 파렛 단위 ' -- [AI] 내부 처리용 변수
    lvl_p01_count  number ;  --양품창고 -- [AI] 내부 처리용 변수
    lvl_p00_count  number ;  --아닌창고  -- [AI] 내부 처리용 변수
    lvl_longterm   number ;  -- [AI] 내부 처리용 변수
    lvs_barcode    varchar2(30); -- [AI] 내부 처리용 변수
    lvs_pallet_no  varchar2(30); -- [AI] 내부 처리용 변수
    lvs_ship_no    varchar2(24);  -- [AI] 내부 처리용 변수
    lvd_issue_date date; -- [AI] 내부 처리용 변수
    lvl_issue_seq  number; -- [AI] 내부 처리용 변수
    lvs_ng_msg     varchar2(4000); -- [AI] 내부 처리용 변수
    lvs_ok_msg     varchar2(4000); -- [AI] 내부 처리용 변수
    
    lvl_fifo_count   number ;  -- [AI] 내부 처리용 변수
    
    lvs_pack_type    varchar2(2); -- [AI] 내부 처리용 변수
    lvl_pack_qty     number     ; -- [AI] 내부 처리용 변수
    lvs_model_name   varchar2(50); -- [AI] 내부 처리용 변수
    lvs_item_code    varchar2(50); -- [AI] 내부 처리용 변수
    
    lvl_count        number ; -- [AI] 내부 처리용 변수
    
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when no_data_found then
           p_out := 'NG' ;
           p_msg := f_msg('존재하지 않는 재고 입니다.','C',1);
           return ;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then 
    p_out := 'NG' ; 
    p_msg := substr(sqlerrm,1,200); 
    
    if p_commit = 'Y' then 
      rollback ; 
    end if; 
      
end P_PRODUCT_FG_MODEL_ISSUE;
