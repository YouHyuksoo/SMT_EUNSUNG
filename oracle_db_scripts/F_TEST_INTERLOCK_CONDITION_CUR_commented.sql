CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_TEST_INTERLOCK_CONDITION_CUR
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   원본 함수 로직을 기준으로 업무 값을 계산, 조회 또는 변환하여 반환한다.
   *   반환 타입은 sys_refcursor이며 호출 위치에서 후속 판단/표시에 사용된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_1  (IN, VARCHAR2) - 함수 입력값
   *   P_2  (IN, VARCHAR2) - 함수 입력값
   *   P_3  (IN, VARCHAR2) - 함수 입력값
   *   P_4  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   sys_refcursor - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_CHECK_CONDITION - 인터락 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_TEST_INTERLOCK_CONDITION_CUR(...) FROM DUAL;
   * ================================================================ */
 "F_TEST_INTERLOCK_CONDITION_CUR" (p_1        IN VARCHAR2,
/* Formatted on 2015-04-07 13:27:50 (QP5 v5.126) */
                                        p_2   IN VARCHAR2,
                                        p_3     IN VARCHAR2,
                                        p_4              IN VARCHAR2)
    RETURN sys_refcursor
IS
    o_cursor        sys_refcursor;
    lvs_item_code   VARCHAR2 (30);
BEGIN
    --lvs_item_code := f_get_model_name_by_pid (p_4);

    OPEN o_cursor FOR
        SELECT   interlock_check_type, check_sequence
          FROM   iq_interlock_check_condition
         WHERE   line_code = p_1 AND machine_code = p_3
         ORDER BY check_sequence ASC ;       --AND item_code = lvs_item_code;

    RETURN o_cursor;
END;
