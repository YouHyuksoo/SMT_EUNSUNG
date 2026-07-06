CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_AOI_RESULT_BY_PID
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
   *   P_PID  (IN, VARCHAR2) - 제품 식별자
   *   P_REPAIR_DATE  (IN, date) - 일자 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_AOI - 검사 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_AOI_RESULT_BY_PID(...) FROM DUAL;
   * ================================================================ */
 "F_GET_AOI_RESULT_BY_PID" (
                                                        p_pid          IN VARCHAR2 ,
                                                        p_repair_date  in date
                                                     )
   RETURN VARCHAR2
IS

   lvs_result         varchar2(50);
   lvs_review         varchar2(50);
   lvs_inspect_date   varchar2(50);
   
BEGIN
---------------------------------------------------------------
-- AOI  최종 Result 확인
---------------------------------------------------------------

    if ( p_repair_date is null ) then
         RETURN NULL;
    end if;
    
    select RESULT, REVIEW_RESULT, inspect_date
      into lvs_result, lvs_review, lvs_inspect_date
      from iq_machine_inspect_data_aoi
     where pid = p_pid
       and inspect_date = (
                            select max(inspect_date)
                              from iq_machine_inspect_data_aoi
                             where pid = p_pid
                               and inspect_date >= to_char(p_repair_date, 'YYYY/MM/DD HH24:MI:ss')
                         );
                         
                         
  --  if ( lvs_result = 'OK' ) THEN
      
  --       RETURN lvs_result;      
         
  --  else
       
         if ( lvs_review is not null ) then
              return lvs_review; --||' : '||lvs_inspect_date; 
         else
              return lvs_result; --||' : '||lvs_inspect_date; 
         end if;
     
  --  end if;           
                      
                      

---------------------------------------------------------------
--
---------------------------------------------------------------

EXCEPTION
   WHEN OTHERS THEN
        RETURN NULL;
END;
