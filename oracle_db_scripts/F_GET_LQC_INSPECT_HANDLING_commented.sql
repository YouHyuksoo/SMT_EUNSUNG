CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_LQC_INSPECT_HANDLING
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
   *   P_LQC_INSPECT_NO  (IN, VARCHAR2) - 검사 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_PRODUCT_LQC_BAD - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_LQC_INSPECT_HANDLING(...) FROM DUAL;
   * ================================================================ */
 "F_GET_LQC_INSPECT_HANDLING" (
   p_lqc_inspect_no   IN   VARCHAR2,
   p_org              IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_lqc_inspect_handling   VARCHAR2 (1);
BEGIN
   SELECT NVL (lqc_inspect_handling, 'N')
     INTO lvs_lqc_inspect_handling
     FROM iq_product_lqc_bad
    WHERE lqc_inspect_no = p_lqc_inspect_no
      AND lqc_inspect_handling = 'D'
      AND organization_id = p_org
      AND ROWNUM = 1;
   RETURN lvs_lqc_inspect_handling;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'N';
   WHEN OTHERS
   THEN
      raise_application_error (-20003,    p_lqc_inspect_no
                                       || ' '
                                       || SQLERRM);
END;
