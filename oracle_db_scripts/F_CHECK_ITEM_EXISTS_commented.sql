CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_CHECK_ITEM_EXISTS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건 또는 기준 데이터의 존재/상태를 확인하여 검증 결과를 반환한다.
   *   화면, 설비, 인터락 로직에서 사전 체크용으로 호출되는 함수로 추정된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_SET_ITEM  (IN, VARCHAR2) - 품목 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_CUSTOMER_SET_BOM - 고객 / BOM 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_CHECK_ITEM_EXISTS(...) FROM DUAL;
   * ================================================================ */
 "F_CHECK_ITEM_EXISTS" (
   p_set_item   IN   VARCHAR2,
   p_org        IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvi_count                     NUMBER;
BEGIN
   SELECT COUNT(*)
   INTO   lvi_count
   FROM   id_customer_set_bom
   WHERE      item_code = p_set_item
          AND item_code <> '*'
          AND organization_id = p_org;

   IF lvi_count > 0
   THEN
      RETURN 'EXISTS';
   ELSE
      RETURN 'NOTFOUND';
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'NOTFOUND';
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;
