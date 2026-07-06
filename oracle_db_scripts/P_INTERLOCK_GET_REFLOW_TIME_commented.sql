CREATE OR REPLACE PROCEDURE "P_INTERLOCK_GET_REFLOW_TIME" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_GET_REFLOW_TIME
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   시리얼 번호 기준으로 인터락 검사 결과의 최초 입고 시간을 조회한다.
   *   IQ_INTERLOCK_CHECK_RESULT에서 가장 이른 RECEIPT_DATE를 yyyymmddhh24mi 형식으로 변환한다.
   *   조회된 시간 문자열을 OUT 파라미터로 반환하여 리플로우 시간 판단에 사용할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_SERIAL_NO  (IN, VARCHAR2) - 조회할 PID/시리얼 번호
   *   P_OUT        (OUT, VARCHAR2) - 최초 입고 시간 문자열 또는 NOTFOUND
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_CHECK_RESULT - 인터락 검사 결과 테이블
   *     조건: SERIAL_NO = P_SERIAL_NO
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN NO_DATA_FOUND - 조회 결과가 없으면 P_OUT에 NOTFOUND를 설정하고 종료한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_GET_REFLOW_TIME('PID0001', :P_OUT)
   * ================================================================ */
p_serial_no IN VARCHAR2, p_out OUT VARCHAR2)
IS
    lvs_return   VARCHAR2 (20); -- [AI] 조회된 최초 입고 시간 문자열 보관 변수
BEGIN
    -- [AI] 시리얼 번호의 최초 입고 일시를 분 단위 문자열로 조회한다.
    SELECT   TO_CHAR (MIN (receipt_date), 'yyyymmddhh24mi')
      INTO   lvs_return
      FROM   iq_interlock_check_result
     WHERE   serial_no = p_serial_no;


    -- [AI] 조회 결과를 OUT 파라미터로 반환한다.
    p_out := lvs_return;
EXCEPTION
    -- [AI] 조회 대상 데이터가 없을 때 호출부가 식별할 수 있는 문자열을 반환한다.
    WHEN NO_DATA_FOUND
    THEN
        p_out := 'NOTFOUND';
        RETURN;
END;
