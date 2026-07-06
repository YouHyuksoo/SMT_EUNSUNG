CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_WORKSTAGE_PASS_RATE
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
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 공정 코드
   *   P_RUN_NO  (IN, VARCHAR) - 작업지시/런 번호
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_CHECK_RESULT - 인터락 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_WORKSTAGE_PASS_RATE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_WORKSTAGE_PASS_RATE" (p_line_code        IN VARCHAR2,
                                                                       p_workstage_code   IN VARCHAR2,
                                                                       p_run_no           IN VARCHAR)
    RETURN NUMBER
IS
    lvf_rate     NUMBER;
    lvf_ng_qty   NUMBER;
    lvf_ok_qty   NUMBER;
BEGIN
    SELECT   SUM (DECODE (check_result, 'OK', 0, 1)) ng_qty, SUM (DECODE (check_result, 'OK', 1, 0)) ok_qty
      INTO   lvf_ng_qty, lvf_ok_qty
      FROM   iq_interlock_check_result
     WHERE   line_code = p_line_code AND workstage_code = p_workstage_code AND run_no = p_run_no;

    IF nvl(lvf_ng_qty,0) + nvl(lvf_ok_qty,0) = 0
    THEN
        RETURN 0;
    ELSE
        lvf_rate :=  TRUNC( lvf_ok_qty / (lvf_ng_qty + lvf_ok_qty) , 3) * 100 ;
    END IF;

    RETURN lvf_rate;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;
