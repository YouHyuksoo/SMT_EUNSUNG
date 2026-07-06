CREATE OR REPLACE PROCEDURE "P_CHECK_GET_LINE_STATUS" (
  /* ================================================================
   * 프로시저명  : P_CHECK_GET_LINE_STATUS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2015-12-16
   * 수정이력:
   *   2015-12-16 - 지성솔루션컨설팅 - PDA용 기존 라인 상태 반환 로직 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   PDA에서 사용할 현재 라인 가동 상태와 경과 시간을 문자열로 반환한다.
   *   종료 시간이 없는 IP_LINE_DAILY_OPERATION의 현재 가동 건을 조회한다.
   *   라인 상태 코드는 F_GET_BASECODE를 통해 요청 언어 기준 명칭으로 변환한다.
   *   조회 실패 또는 오류 발생 시 P_OUT에 N을 반환한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_ORG   (IN, NUMBER) - 조직 ID
   *   P_LINE  (IN, VARCHAR2) - 조회할 라인 코드
   *   P_LANG  (IN, VARCHAR2) - 라인 상태명 조회 언어 코드
   *   P_OUT   (OUT, VARCHAR2) - 라인 상태명과 경과 시간 문자열 또는 N
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_LINE_DAILY_OPERATION - 라인 일일 가동 이력 테이블
   *     조건: ORGANIZATION_ID, LINE_CODE 일치 및 END_TIME IS NULL
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_BASECODE - LINE STATUS 코드명을 언어/조직 기준으로 조회
   * ================================================================
   * [AI 분석] 예외 처리:
   *   내부 WHEN OTHERS - 현재 상태 조회 실패 시 P_OUT에 N 설정
   *   외부 WHEN OTHERS - 기타 오류 발생 시 P_OUT에 N 설정
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_GET_LINE_STATUS(82, 'L1', 'KO', :P_OUT)
   * ================================================================ */
 p_org in number ,
                                                  p_line in varchar2,
                                                  p_lang in varchar2,
                                                  p_out out varchar2 ) is
    /**************************************************
    * 2015.12.16
    * 기존 라인상태를 반환 ( PDA 사용시 )
    ***************************************************/

begin
  -- [AI] 현재 라인 상태 조회 실패를 개별 처리하기 위한 내부 블록이다.
  begin
    -- [AI] 종료되지 않은 라인 가동 건의 상태명과 시작 후 경과 시간을 조회한다.
    select f_get_basecode( 'LINE STATUS', LINE_STATUS_CODE, p_lang,p_org)||chr(10)||
           substr(numtodsinterval((sysdate - start_time) , 'day'),9,2)||' Day '||substr(numtodsinterval((sysdate - start_time) , 'day'),12,8) as TIME
      into p_out
      from IP_LINE_DAILY_OPERATION t
     where organization_id = p_org
       and line_code       = p_line
       and end_time is null
       and rownum = 1
      order by start_time ;

  exception
    -- [AI] 현재 라인 상태를 찾지 못하거나 조회 오류가 발생하면 N을 반환한다.
    when others then
      p_out := 'N' ;
  end ;
exception
    -- [AI] 외부 블록의 기타 오류 발생 시에도 N을 반환한다.
    when others then
      p_out := 'N' ;
end P_CHECK_GET_LINE_STATUS;
