CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_WORKTIME_SEC
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
   *   P_START_TIME  (IN, date) - 시간 관련 값
   *   P_END_TIME  (IN, date) - 시간 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   number - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_WORK_TIME - 제품 / 시간 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORK_ACTUAL_DATE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 6회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_WORKTIME_SEC(...) FROM DUAL;
   * ================================================================ */
 "F_GET_WORKTIME_SEC" (p_start_time date,
                                                 p_end_time   date ) 
return number is
  lvl_Result number;
  
  lvs_start varchar2(10);
  lvs_end   varchar2(10);
  
begin
  
   lvs_start := to_char(p_start_time, 'HH24MI');
   lvs_end   := to_char(p_end_time, 'HH24MI');
   
   
   SELECT SUM( ( TO_DATE( R_END_TIME, 'hh24mi') - TO_DATE( R_START_TIME, 'HH24MI') ) * 24 * 60 * 60 ) 
     INTO LVL_RESULT 
     FROM
          (  
                select START_TIME, 
                       END_TIME  , 
                       DECODE( SIGN(START_TIME - lvs_start), -1, lvs_start, START_TIME) AS R_START_TIME , 
                       DECODE( SIGN(lvs_end- END_TIME), 1, END_TIME, lvs_end)       AS R_END_TIME 
                  from IP_PRODUCT_WORK_TIME t
                 where  start_time   <=lvs_end  --종료 시간 
                   and  end_time     >= lvs_start  --시작시간         
                   and work_date     = f_get_work_actual_date(sysdate,'A')
                   and time_division <> 'R' 
           ) ; 
   
   /*
   select sum(time_diff) * 24 *60 *60
     into lvl_Result
    from (
          select nvl(to_date(to_char(sysdate, 'YYYYMMDD')||end_time,'YYYYMMDDHH24MISS')  - to_date(to_char(sysdate, 'YYYYMMDD')||lvs_start,'YYYYMMDDHH24MISS'),0) time_diff
            from ICOM_WORKTIME_RANGES
           where start_time <  lvs_start
             and end_time   >= lvs_start
             and range_type = 'MAIN LINE TARGET'
             and organization_id = 1
           union all
          select nvl(to_date(to_char(sysdate, 'YYYYMMDD')||end_time,'YYYYMMDDHH24MISS') -  to_date(to_char(sysdate, 'YYYYMMDD')||start_time,'YYYYMMDDHH24MISS'),0)  time_diff
            from ICOM_WORKTIME_RANGES
           where start_time >= lvs_start
             and end_time   <= lvs_end  
             and range_type = 'MAIN LINE TARGET'
             and organization_id = 1
           union all 
          select nvl(to_date(to_char(sysdate, 'YYYYMMDD')||lvs_end,'YYYYMMDDHH24MISS') - to_date(to_char(sysdate, 'YYYYMMDD')||start_time,'YYYYMMDDHH24MISS'),0) time_diff
            from ICOM_WORKTIME_RANGES
           where start_time <= lvs_end
             and end_time   >  lvs_end 
             and range_type = 'MAIN LINE TARGET'
             and organization_id = 1
         );
     */
        
  return lvl_Result;

exception
  when others then
       return 0;
end ;
