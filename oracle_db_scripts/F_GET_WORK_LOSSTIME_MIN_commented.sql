CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_WORK_LOSSTIME_MIN
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
   *   P_LINE_CODE  (IN, varchar2) - 라인 코드
   *   P_START_TIME  (IN, date) - 시간 관련 값
   *   P_END_TIME  (IN, date) - 시간 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   number - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_MACHINE_DAILY_OPERATION - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_WORK_LOSSTIME_MIN(...) FROM DUAL;
   * ================================================================ */
 "F_GET_WORK_LOSSTIME_MIN" (
                                                        p_line_code  varchar2,
                                                        p_start_time date,
                                                        p_end_time   date 
                                                      ) 
return number is
  lvl_Result number;
  
begin
  
   select NVL( SUM( DECODE( p_start_time, NULL, 0, DECODE( p_end_time, NULL, 0, (( DECODE( SIGN(p_end_time - END_TIME), 1, END_TIME, p_end_time)  - DECODE( SIGN(START_TIME - p_start_time), -1, p_start_time, START_TIME) ) * (24*60)) ) ) ) ,0)          
     into lvl_Result
     from IMCN_MACHINE_DAILY_OPERATION
    where line_code  =  p_line_code
      and start_time <= p_end_time
      and end_time   >= p_start_time;
             
        
  return lvl_Result;

exception
  when others then
       return 0;
end ;
