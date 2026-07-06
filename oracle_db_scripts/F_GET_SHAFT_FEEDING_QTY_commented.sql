CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_SHAFT_FEEDING_QTY
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
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_LOCATION_CODE  (IN, VARCHAR2) - 위치 코드
   *   P_PCB_ITEM  (IN, VARCHAR2) - PCB / 품목 관련 값
   *   P_FEEDER_SHAFT  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_SHAFT_FEEDING_QTY(...) FROM DUAL;
   * ================================================================ */
 "F_GET_SHAFT_FEEDING_QTY" (
   P_LINE_CODE       IN VARCHAR2,
   P_MODEL_NAME      IN VARCHAR2,
   P_LOCATION_CODE   IN VARCHAR2,
   P_PCB_ITEM        IN VARCHAR2,
   P_FEEDER_SHAFT IN VARCHAR2 )
   RETURN NUMBER
IS
   LVL_RETURN   NUMBER;
BEGIN
   LVL_RETURN := 0;

   SELECT SUM (NVL (FEEDING_QTY, 0))
     INTO LVL_RETURN
     FROM IB_PRODUCT_PLANDATA
    WHERE     LINE_CODE = P_LINE_CODE
          AND MODEL_NAME = P_MODEL_NAME
          AND LOCATION_CODE = P_LOCATION_CODE
          AND PCB_ITEM = P_PCB_ITEM
          AND ACTIVE_YN = 'Y'
          AND FEEDER_SHAFT = P_FEEDER_SHAFT ;


   RETURN LVL_RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
      RETURN 0;
END;
