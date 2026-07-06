CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_SALE_ORDER_UPLOAD_SQL
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
   *   P_DIVISION  (IN, VARCHAR2) - 함수 입력값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IS_PRODUCT_ORDER_UPLOAD - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_SALE_ORDER_UPLOAD_SQL(...) FROM DUAL;
   * ================================================================ */
 "F_GET_SALE_ORDER_UPLOAD_SQL" (
   p_division   IN   VARCHAR2,
   p_org        IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_sql                       VARCHAR2(2000);
BEGIN
   IF p_division = 'LGERP'
   THEN

      lvs_sql :=
            'SELECT
                   NO,
                   PART_NO,
                   ORDER_TYPE,
                   ORDER_NO,
                   NEED_BY_DATE,
                   ORDER_DATE,
                   MARKET,
                   ITEM_TYPE,
                   ORDER_QTY,
                   REMAINED_QTY,
                   DEPARTURE_QTY,
                   RECEIVING_QTY,
                   CANCELED_FLAG,
                   SUBINVENTORY,
                   LINE_CODE,
                   WORK_ORDER,
                   ITEM_DESC,
                   ITEM_SPEC,
                   ARRIVAL_SUPPLIER_CODE,
                   ARRIVAL_SUPPLIER_NAME,
                   CURR,
                   UNIT_PRICE,
                   PACKING_UNIT,
                   REQUIRED_QTY,
                   QPA,
                   ISSUE_QTY,
                   ASSEMBLY_PART_NO,
                   DELIVERY_TYPE,
                   REQUESTOR_NAME,
                   REQUEST_DEPT_CODE,
                   MIX_INFO,
                   UPLOAD_YN,
                   UPLOAD_DATE,
                   CUSTOMER_CODE,
                   ORGANIZATION_ID
       FROM IS_PRODUCT_ORDER_UPLOAD
     WHERE ORGANIZATION_ID ='
            || p_org;
   END IF;

   RETURN lvs_sql;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;
