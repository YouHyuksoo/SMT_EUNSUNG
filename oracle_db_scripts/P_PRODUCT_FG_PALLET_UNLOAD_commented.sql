CREATE OR REPLACE PROCEDURE "P_PRODUCT_FG_PALLET_UNLOAD" (p_pallet  varchar2,
  /* ================================================================
   * 프로시저명  : P_PRODUCT_FG_PALLET_UNLOAD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   제품 또는 재고 관련 업무 데이터를 등록/갱신한다.
   *   대상 재고와 실적 데이터의 존재 여부를 확인한 뒤 원본 로직에 따라 처리한다.
   *   COMMIT/ROLLBACK 포함 여부는 원본 트랜잭션 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PALLET - 원본 선언부 기준 입력/출력 파라미터
   *   P_COMMIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PDA - 원본 선언부 기준 입력/출력 파라미터
   *   P_COMMIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PALLET_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_PALLET - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PALLET - 원본 선언부 기준 입력/출력 파라미터
   *   P_PALLET - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   P_PALLET - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 원본 로직 참조 테이블
   *   IP_PRODUCT_FG_INVENTORY - 원본 로직 참조 테이블
   *   IP_PRODUCT_FG_PALLET - 파렛트 작업 마스터 ( 재고테이블을 이용)
   *   IP_PRODUCT_PACK_MASTER - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_PRODUCT_FG_PALLET_UNLOAD(...)
   * ================================================================ */
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
   
    lvs_pallet_status varchar2(1); -- [AI] 내부 처리용 변수
    lvs_ship_flag     varchar2(1) ;  -- [AI] 내부 처리용 변수
    lvs_p_model       varchar2(30);  -- [AI] 내부 처리용 변수
    lvs_p_suffix      varchar2(30);  -- [AI] 내부 처리용 변수
    
    
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
    /******************************
    * 파렛 정보 확인  
    ******************************/
    begin 
      select x.pallet_status, x.ship_flag, x.model_name, x.model_suffix
        into lvs_pallet_status, lvs_ship_flag, lvs_p_model, lvs_p_suffix 
        from ip_product_fg_pallet x
       where x.pallet_no = p_pallet ; 
    exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when no_data_found then 
        p_out := 'NG' ; 
        p_msg := f_msg('존재하지 않는 Pallet 입니다.','C',1)||' '||p_pallet ;
        return ;     
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then 
    p_out := 'NG' ; 
    p_msg := substr(sqlerrm,1,200); 
    
    if p_commit = 'Y' then 
      rollback ; 
    end if; 
      
end P_PRODUCT_FG_PALLET_UNLOAD;
