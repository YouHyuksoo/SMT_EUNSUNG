CREATE OR REPLACE function
  /* ================================================================
   * 함수명  : F_GET_PRODUCT_BOX_YYYYMMDDNN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_YYYYMMDD  (IN, varchar2) - 함수 입력값
   *   P_RUN_NO  (IN, varchar2) - 작업지시/런 번호
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_CARD - 제품 / 작업지시/런 관련 값 조회 또는 참조
   *   IP_PRODUCT_BOX_YYYYMMDDNN - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 5회, INSERT 1회 / 주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_PRODUCT_BOX_YYYYMMDDNN(...) FROM DUAL;
   * ================================================================ */
 f_get_product_box_yyyymmddnn (
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
