CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MODEL_ST
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
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_TYPE  (IN, VARCHAR2) - 함수 입력값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MODEL_ST_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 2회 / 반복문: 0회
   *   DML: SELECT 4회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MODEL_ST(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MODEL_ST" (
   P_MODEL_NAME   IN VARCHAR2,
   P_LINE_CODE    IN VARCHAR2,
   P_TYPE         IN VARCHAR2,
   P_ORG          IN NUMBER)
   RETURN NUMBER
IS
   LVL_ST   NUMBER;
BEGIN
   LVL_ST := 0;

   IF P_TYPE = 'A'                                                     -- ？？u？？？
   THEN
      SELECT SUM (PRODUCT_ST)
        INTO LVL_ST
        FROM IP_PRODUCT_MODEL_ST_MASTER
       WHERE     MODEL_NAME = P_MODEL_NAME
             AND LINE_CODE = P_LINE_CODE
             AND ORGANIZATION_ID = P_ORG;
   ELSIF P_TYPE = 'B'                                                    --？？？？
   THEN
      SELECT MAX (PRODUCT_ST)
        INTO LVL_ST
        FROM IP_PRODUCT_MODEL_ST_MASTER
       WHERE     MODEL_NAME = P_MODEL_NAME
             AND LINE_CODE = P_LINE_CODE
             AND PCB_ITEM = P_TYPE
             AND ORGANIZATION_ID = P_ORG;
   ELSIF P_TYPE = 'T'
   THEN
      SELECT MAX (PRODUCT_ST)
        INTO LVL_ST
        FROM IP_PRODUCT_MODEL_ST_MASTER
       WHERE     MODEL_NAME = P_MODEL_NAME
             AND PCB_ITEM = P_TYPE
             AND LINE_CODE = P_LINE_CODE
             AND ORGANIZATION_ID = P_ORG;
   ELSE
      SELECT MAX (PRODUCT_ST)
        INTO LVL_ST
        FROM IP_PRODUCT_MODEL_ST_MASTER
       WHERE     MODEL_NAME = P_MODEL_NAME
             AND LINE_CODE = P_LINE_CODE
             AND ORGANIZATION_ID = P_ORG;
   END IF;

   RETURN NVL (LVL_ST, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      LVL_ST := 0;
   WHEN OTHERS
   THEN
      LVL_ST := 0;
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END F_GET_MODEL_ST;
