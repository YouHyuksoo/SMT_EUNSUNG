CREATE OR REPLACE FUNCTION F_GET_MACHINE_REAL_BAD_QTY (
  /* ================================================================
   * 함수명  : F_GET_MACHINE_REAL_BAD_QTY
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-10-12
   * 수정이력:
   *   2026-10-12 - AI(Claude)       - 최초 작성
   * ================================================================
   * [AI 분석] 기능 설명:
   *   설비코드와 기간(From~To)을 받아 해당 설비의 진성불량 수량을 반환한다.
   *   진성불량 = IP_PRODUCT_WORK_QC 중 후처리(QC_INSPECT_HANDLING)가 'D'(폐기)인 건의
   *   불량수량(BAD_QTY) 합계다.
   *   기간은 검사일자(QC_DATE) 기준 날짜 단위이며 From·To 양 끝 날짜를 모두 포함한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_MACHINE_CODE  (IN, VARCHAR2) - 설비코드 (IP_PRODUCT_WORK_QC.MACHINE_CODE)
   *   P_FROM_DATE     (IN, DATE)     - 조회 시작일 (시각은 무시, 당일 00:00부터)
   *   P_TO_DATE       (IN, DATE)     - 조회 종료일 (시각은 무시, 당일 23:59:59까지)
   *   P_ORG           (IN, NUMBER, 기본값: 1) - 조직ID
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 진성불량 수량 (해당 건이 없으면 0)
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_WORK_QC - 공정 검사(불량) 이력. 후처리 'D'=폐기 건의 BAD_QTY를 합산
   * ================================================================
   * [AI 분석] 예외 처리:
   *   집계 함수라 NO_DATA_FOUND가 나지 않으며, 대상이 없으면 NVL로 0을 반환한다.
   *   그 외 오류는 호출자에게 그대로 전달한다 (0으로 덮으면 실제 오류가 숨는다).
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MACHINE_REAL_BAD_QTY('KH-600709',
   *          TO_DATE('2026-10-01','YYYY-MM-DD'), TO_DATE('2026-10-12','YYYY-MM-DD'))
   *     FROM DUAL;
   * ================================================================ */
  P_MACHINE_CODE IN VARCHAR2,
  P_FROM_DATE    IN DATE,
  P_TO_DATE      IN DATE,
  P_ORG          IN NUMBER DEFAULT 1
) RETURN NUMBER
IS
  LVL_RETURN NUMBER := 0;  -- 진성불량 수량
BEGIN
  -- [AI Step 1] 설비·기간·조직 조건으로 후처리 '폐기(D)' 건의 불량수량 합계
  --             To 날짜는 다음날 0시 미만으로 비교해 당일 전체를 포함한다
  SELECT NVL(SUM(BAD_QTY), 0)
    INTO LVL_RETURN
    FROM IP_PRODUCT_WORK_QC
   WHERE MACHINE_CODE        = P_MACHINE_CODE
     AND QC_INSPECT_HANDLING = 'D'
     AND QC_DATE            >= TRUNC(P_FROM_DATE)
     AND QC_DATE             < TRUNC(P_TO_DATE) + 1
     AND ORGANIZATION_ID     = P_ORG;

  RETURN LVL_RETURN;
END F_GET_MACHINE_REAL_BAD_QTY;
/
