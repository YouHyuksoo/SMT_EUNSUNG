CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_CHECK_ITEM_LOT_BLOCKING
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
   *   P_MATERIAL_MFS  (IN, VARCHAR2) - 제조/공급 구분
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_INVENTORY_HOLD - 품목 / 재고 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_CHECK_ITEM_LOT_BLOCKING(...) FROM DUAL;
   * ================================================================ */
 "F_CHECK_ITEM_LOT_BLOCKING" (
   p_material_mfs IN VARCHAR2)
   RETURN NUMBER
IS
   lvi_count   NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IM_ITEM_INVENTORY_HOLD
       WHERE     MATERIAL_MFS = P_MATERIAL_MFS
             AND INVENTORY_STATUS = 'H'
             AND ORGANIZATION_ID = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

   RETURN NVL (LVI_COUNT, 0);
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END F_CHECK_ITEM_LOT_BLOCKING;
