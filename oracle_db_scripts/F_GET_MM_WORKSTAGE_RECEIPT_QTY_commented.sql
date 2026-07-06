CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MM_WORKSTAGE_RECEIPT_QTY
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
   *   AS_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   AS_WORKSTAGE_CODE  (IN, VARCHAR2) - 공정 코드
   *   AS_MFS  (IN, VARCHAR2) - 제조/공급 구분
   *   AS_MATERIAL_MFS  (IN, VARCHAR2) - 제조/공급 구분
   *   AS_ITEM_CODE  (IN, VARCHAR2) - 품목 코드
   *   AS_YYYYMM  (IN, VARCHAR2) - 함수 입력값
   *   AI_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_WORKSTAGE_RECEIPT - 품목 / 공정 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_INVENTORY_CLOSE_DATE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MM_WORKSTAGE_RECEIPT_QTY(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MM_WORKSTAGE_RECEIPT_QTY" (
   as_line_code        IN   VARCHAR2,
   as_workstage_code   IN   VARCHAR2,
   as_mfs              IN   VARCHAR2,
   as_material_mfs     IN   VARCHAR2,
   as_item_code        IN   VARCHAR2,
   as_yyyymm           IN   VARCHAR2,
   ai_org              IN   NUMBER
)
   RETURN NUMBER
IS
   al_receipt_qty                NUMBER;
BEGIN
   SELECT NVL(SUM(receipt_qty), 0)
   INTO   al_receipt_qty
   FROM   im_item_workstage_receipt
   WHERE  item_code = as_item_code                                              AND
          receipt_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id ) AND
--          receipt_status <> 'C'                                                 AND
          line_code = as_line_code                                              AND
          workstage_code = as_workstage_code                                    AND
          mfs = as_mfs                                                          AND
          material_mfs = as_material_mfs                                        AND
          organization_id = ai_org;
   RETURN al_receipt_qty;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error(-20003, SQLERRM);
   WHEN OTHERS
   THEN
      ROLLBACK;
      raise_application_error(-20003, SQLERRM);
END;
