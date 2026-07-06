CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_PRODUCT_ST
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
   *   P_ITEM_CODE  (IN, VARCHAR2) - 품목 코드
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_WORKSTATE_CODE  (IN, VARCHAR2) - 함수 입력값
   *   P_MACHINE_CODE  (IN, VARCHAR2) - 함수 입력값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_CONFIG - 환경설정 관련 값 조회 또는 참조
   *   IP_PRODUCT_ST - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 4회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_PRODUCT_ST(...) FROM DUAL;
   * ================================================================ */
 "F_GET_PRODUCT_ST" (
   p_item_code        IN   VARCHAR2,
   p_line_code        IN   VARCHAR2,
   p_workstate_code   IN   VARCHAR2,
   p_machine_code     IN   VARCHAR2,
   p_org              IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_st             NUMBER;
   lvs_config_value   VARCHAR2 (1);
BEGIN
------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
   BEGIN
      SELECT NVL (config_value, 'Y')
        INTO lvs_config_value
        FROM isys_config
       WHERE config_name = 'PRODUCT_ST_BY_ITEM'
         AND use_yn = 'Y'
         AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_config_value := 'Y';
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   IF lvs_config_value = 'Y'
   THEN
---------------------------------------
-- BY ITEM
---------------------------------------
      SELECT MIN (NVL (st_value, 0))
        INTO lvf_st
        FROM ip_product_st
       WHERE item_code = p_item_code AND organization_id = p_org;
   ELSE
      IF p_line_code = '%'
      THEN
         SELECT MIN (NVL (st_value, 0))
           INTO lvf_st
           FROM ip_product_st
          WHERE item_code = p_item_code AND organization_id = p_org;
      ELSE
---------------------------------------
--
---------------------------------------
         SELECT NVL (st_value, 0)
           INTO lvf_st
           FROM ip_product_st
          WHERE item_code = p_item_code
            AND line_code = p_line_code
            AND workstage_code = p_workstate_code
            AND machine_code = p_machine_code
            AND organization_id = p_org;
      END IF;
   END IF;

   RETURN lvf_st;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
