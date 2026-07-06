CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_TODAY_START_TIME
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
   *   P_DATE  (IN, date) - 일자 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   date - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_WORKTIME_RANGES - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_TODAY_START_TIME(...) FROM DUAL;
   * ================================================================ */
 "F_GET_TODAY_START_TIME" (p_date date)
return date is
  
lvd_date date;
LVS_START_TIME VARCHAR2(10) ;  
begin

  
 SELECT START_TIME INTO LVS_START_TIME 
   FROM ICOM_WORKTIME_RANGES 
  WHERE range_type = 'SMTWORKTIME'  AND work_type = 'A' ;
 

  IF LVS_START_TIME = '' OR LVS_START_TIME IS NULL THEN 
        LVS_START_TIME := '0830' ;
  END IF ;
  
    select DECODE(SIGN(TO_CHAR(p_date,'HH24MI') - LVS_START_TIME),-1,  to_date( TO_CHAR(p_date - 1 , 'YYYYMMDD')||LVS_START_TIME  , 'yyyymmddhh24miss') ,  to_date( TO_CHAR(p_date  , 'YYYYMMDD')||LVS_START_TIME  , 'yyyymmddhh24miss')    )
      into lvd_date
      from dual ;
 
  return lvd_date ;

end ;
