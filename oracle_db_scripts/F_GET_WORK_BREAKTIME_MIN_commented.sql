CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_WORK_BREAKTIME_MIN
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
   *   ICOM_WORKTIME_RANGES - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 3회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_WORK_BREAKTIME_MIN(...) FROM DUAL;
   * ================================================================ */
 "F_GET_WORK_BREAKTIME_MIN" (
                                                        p_start_time date,
                                                        p_end_time   date 
                                                      ) 
return number is
  lvl_Result number;
  
  lvs_start varchar2(20);
  lvs_end   varchar2(20);
  
begin
  
   select to_char(trunc(sysdate) + decode(sign(to_char(p_start_time, 'HH24MI') - '0830'),-1,1,0),'YYYYMMDD')||to_char(p_start_time, 'HH24MI'),
          to_char(trunc(sysdate) + decode(sign(to_char(p_end_time, 'HH24MI') - '0830'),-1,1,0,1,0),'YYYYMMDD')||to_char(p_end_time, 'HH24MI')
     into lvs_start, lvs_end
    from dual; 
           
   lvl_Result := 0;
   
   select nvl( sum( decode( attribute03, 0, 0, (to_date(R_END_TIME, 'YYYYMMDDHH24MISS') - to_date(R_START_TIME, 'YYYYMMDDHH24MISS'))*(24*60) ) ), 0)
     into lvl_Result
     from (   
             select start_time, end_time, attribute03,
                    DECODE( SIGN( (to_char(trunc(sysdate) + decode(sign(start_time - '0830'),-1,1,0),'YYYYMMDD')||start_time) - lvs_start ), -1, lvs_start, (to_char(trunc(sysdate) + decode(sign(start_time - '0830'),-1,1,0),'YYYYMMDD')||start_time) ) AS R_START_TIME, 
                    DECODE( SIGN( lvs_end - (to_char(trunc(sysdate) + decode(sign(end_time - '0830'),-1,1,0,1,0),'YYYYMMDD')||end_time) ), 1, (to_char(trunc(sysdate) + decode(sign(end_time - '0830'),-1,1,0,1,0),'YYYYMMDD')||end_time), lvs_end )        AS R_END_TIME 
               from icom_worktime_ranges
              where range_type = 'BRAEKTIME'
                and to_char(trunc(sysdate) + decode(sign(start_time - '0830'),-1,1,0),'YYYYMMDD') || start_time   <= lvs_end
                and to_char(trunc(sysdate) + decode(sign(end_time   - '0830'),-1,1,0,1,0),'YYYYMMDD') || end_time >= lvs_start
          );
        
  return lvl_Result;

exception
  when others then
       return 0;
end ;
