CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_SALE_PLAN_UPLOAD_SQL
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
   *   IS_PRODUCT_SALE_PLAN_UPLOAD - 제품 / 계획 관련 값 조회 또는 참조
   *   IS_PRODUCT_SALE_PLAN_UPLOAD2 - 제품 / 계획 관련 값 조회 또는 참조
   *   IS_PRODUCT_SALE_PLAN_UPLOAD4 - 제품 / 계획 관련 값 조회 또는 참조
   *   IS_PRODUCT_SALE_PLAN_UPLOAD3 - 제품 / 계획 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 3회 / 반복문: 0회
   *   DML: SELECT 4회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_SALE_PLAN_UPLOAD_SQL(...) FROM DUAL;
   * ================================================================ */
 "F_GET_SALE_PLAN_UPLOAD_SQL" (
   p_division   IN   VARCHAR2,
   p_org        IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_sql                       VARCHAR2(2000);
BEGIN
   IF p_division = 'LGESY'
   THEN
      lvs_sql :=
            'SELECT PART_NO,
           MARKET,
           TYPE,
           ORDER_NO,
           ORDER_DATE,
           DUE_DATE,
           ORDER_QTY,
           ORDER_REMAIN_QTY,
           WORK_ORDER,
           ORDER_TYPE,
           DESCRIPTION,
           ITEM_SPEC,
           ITEM_UOM,
           CURRENCY,
           UNIT_PRICE,
           DEPARTURE_QTY,
           RECEIVED_QTY,
           ASSY_PART_NIO,
           SUFFIX,
           LINE,
           REQUESTOR,
           REQUESTOR_DEPT,
           DIVISION,
           MIXED_MODEL,
           CANCEL,
           UPLOAD_DATE,
           ORGANIZATION_ID ,
           CUSTOMER_CODE ,
           EXCHANGE_RATE
      FROM IS_PRODUCT_SALE_PLAN_UPLOAD
     WHERE ORGANIZATION_ID ='
            || p_org;
   ELSIF p_division = 'LGETA'
   THEN
      lvs_sql :=
            'SELECT LINE,
            WORK_ORDER,
            MODEL_SUFFIX,
            TOTAL_QTY,
            REMAINS,
            DATE1,
            DATE2,
            DATE3,
            DATE4,
            DATE5,
            DATE6,
            DATE7,
            DATE8,
            DATE9,
            DATE10,
            DATE11,
            DATE12,
            DATE13,
            DATE14,
            DATE15,
            DATE16,
            DATE17,
            DATE18,
            DATE19,
            DATE20,
            DATE21,
            DATE22,
            DATE23,
            DATE24,
            DATE25,
            DATE26,
            DATE27,
            DATE28,
            DATE29,
            DATE30,
            DATE31,
            DATE32,
            DATE33,
            DATE34,
            DATE35,
            DUE_DATE,
            MARKET,
            BUYER,
            SERISE,
            MIXED_MODEL,
            MIXED_SEQ,
            NEW_MODEL_CLASS,
            PRODUCTION_INPUT_TIME,
            DIVISION,
            ITEM_CODE,
            CURRENCY ,
            UPLOAD_DATE,
            UPLOAD_YN,
            CUSTOMER_CODE,
            EXCHANGE_RATE,
            ORGANIZATION_ID
       FROM IS_PRODUCT_SALE_PLAN_UPLOAD2
      WHERE ORGANIZATION_ID ='
            || p_org;
   ELSIF p_division = 'LGERP'
   THEN

      lvs_sql :=
            'SELECT NO ,
                LINE_CODE,
                SCHEDULE,
                WORK_ORDER,
                PART_NO,
                TOTAL,
                REMAIN_QTY,
                DATE1,
                DATE2,
                DATE3,
                DATE4,
                DATE5,
                DATE6,
                DATE7,
                DATE8,
                DATE9,
                DATE10,
                DATE11,
                DATE12,
                DATE13,
                DATE14,
                DATE15,
                PROD_PERIOD,
                PRIORITY,
                NEED_BY_DATE,
                MARKET,
                BUYER,
                MIX_SEQ_NO,
                MIX_INFO,
                MIX_RATE,
                START_TIME,
                ITEM_CODE,
                CURRENCY ,
                UPLOAD_DATE,
                UPLOAD_YN,
                CUSTOMER_CODE,
                EXCHANGE_RATE,
                ORGANIZATION_ID
       FROM IS_PRODUCT_SALE_PLAN_UPLOAD4
      WHERE ORGANIZATION_ID ='|| p_org
       ;
   ELSIF p_division = 'SAMSUNG'
   THEN
      lvs_sql :=
            'SELECT
            START_DATE, START_TIME,
            END_DATE,
            DO_NO, PO_NO,
            ITEM_CODE,
            MAIN_ITEM,
            ITEM_PROPERTY,
            ORDER_QTY,
            LINE_CODE,
            UPLOAD_DATE,
            UPLOAD_YN,
            ORGANIZATION_ID
       FROM IS_PRODUCT_SALE_PLAN_UPLOAD3
     WHERE ORGANIZATION_ID ='
            || p_org;
   END IF;

   RETURN lvs_sql;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;
