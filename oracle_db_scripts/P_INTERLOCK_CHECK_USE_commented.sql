CREATE OR REPLACE PROCEDURE "P_INTERLOCK_CHECK_USE" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_CHECK_USE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   라인, 공정, 검사 순번 기준으로 인터락 검사 조건 등록 여부를 확인한다.
   *   IQ_INTERLOCK_CHECK_CONDITION에서 조건 건수를 조회하고 존재하면 Y, 없으면 N을 반환한다.
   *   예외 발생 시에도 N을 반환하여 호출부가 인터락 미사용처럼 처리하게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE       (IN, VARCHAR2) - 조회할 라인 코드
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 조회할 공정 코드
   *   P_CHECK_SEQUENCE  (IN, NUMBER) - 조회할 인터락 검사 순번
   *   P_OUT             (OUT, VARCHAR2) - 사용 여부 결과, Y 또는 N
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_CHECK_CONDITION - 라인/공정별 인터락 검사 조건 관리 테이블
   *     조건: LINE_CODE, WORKSTAGE_CODE, CHECK_SEQUENCE 일치
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - 오류 발생 시 P_OUT에 N을 설정하고 종료한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_CHECK_USE('L1', 'W010', 1, :P_OUT)
   * ================================================================ */
p_line_code        IN     VARCHAR2,
                                                  p_workstage_code     IN     VARCHAR2,
                                                  p_check_sequence   IN     NUMBER,
                                                  p_out                 OUT VARCHAR2)
IS
    lvi_count   NUMBER; -- [AI] 조건에 맞는 인터락 설정 건수
BEGIN
------------------------------------------------------------------
--
-----------------------------------------------------------------
    -- [AI] 라인/공정/검사순번 기준의 인터락 조건 존재 여부를 조회한다.
    SELECT   COUNT ( * )
      INTO   lvi_count
      FROM   iq_interlock_check_condition
     WHERE   line_code = p_line_code
       AND  workstage_code = p_workstage_code
       AND check_sequence = p_check_sequence;


    -- [AI] 인터락 조건 존재 여부에 따라 사용 여부 결과를 반환한다.
    IF lvi_count > 0
    THEN
        p_out := 'Y';
    ELSE
        p_out := 'N';
    END IF;

    RETURN;
EXCEPTION
    -- [AI] 오류 발생 시 안전하게 미사용 결과로 반환한다.
    WHEN OTHERS
    THEN
        p_out := 'N';
        RETURN;
END;                                                                                                        -- Procedure
