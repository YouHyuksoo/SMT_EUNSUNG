CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_WORKTIME_ZONE
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
   *   P_DATE  (IN, varchar2) - 일자 관련 값
   *   P_TIME  (IN, varchar2) - 시간 관련 값
   *   P_OPTION  (IN, varchar2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_WORKTIME_RANGES - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_WORKTIME_ZONE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_WORKTIME_ZONE" (p_date   varchar2,
                                                  p_time   varchar2,
                                                  p_option varchar2 default 'ZONE' 
                                                 ) return  varchar2 is
  Result varchar2(5);
  LVS_DATE VARCHAR(8);
begin

  if p_time >= '0000' AND p_time < '0830' THEN

    select work_type
      into Result
      from icom_worktime_ranges x
     where ( to_date(start_time,'HH24MI') + NVL(TO_NUMBER(x.attribute01),0)) <= to_date(p_time,'hh24mi')  + 1
       and ( to_date(end_time,'HH24MI')   + NVL(TO_NUMBER(x.attribute02),0)) >  to_date(p_time,'hh24mi')  + 1
       and range_type = 'WORKTIME'  ;

    LVS_DATE := TO_CHAR(to_date(p_date,'yyyymmdd') - 1 , 'YYYYMMDD') ;
    
  else
    
    select work_type
      into Result
      from icom_worktime_ranges x
     where ( to_date(start_time,'HH24MI') + NVL(TO_NUMBER(x.attribute01),0)) <= to_date(p_time,'hh24mi')
       and ( to_date(end_time,'HH24MI')   + NVL(TO_NUMBER(x.attribute02),0)) >  to_date(p_time,'hh24mi')
       and range_type = 'WORKTIME'  ;

    LVS_DATE := p_date ;
    
  end if ;

  if p_option = 'ZONE' then
    return(Result);
  else
    return LVS_DATE;
  end if;

exception
  when others then
    
    if p_option = 'ZONE' then
       return('Z');
    else
      return p_date ;
    end if;

end ;
