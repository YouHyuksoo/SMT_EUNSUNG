CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_CHECK_RECEIPT_BARCODE_EXISTS
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
   *   P_BARCODE  (IN, VARCHAR2) - 바코드
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_RECEIPT_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_CHECK_RECEIPT_BARCODE_EXISTS(...) FROM DUAL;
   * ================================================================ */
 "F_CHECK_RECEIPT_BARCODE_EXISTS" (
   p_barcode     IN VARCHAR2,
   p_org         IN NUMBER)
   RETURN VARCHAR2
IS
   lvl_cnt   NUMBER;
BEGIN

   --------------------------------------------------------------------
   -- 2016/10/17 SHS, ？？？？？？？？？？check ？？？ ？？？翩？？return
   --------------------------------------------------------------------

   BEGIN

      SELECT COUNT(*)
        INTO lvl_cnt
        FROM IM_ITEM_RECEIPT_BARCODE
       WHERE ITEM_BARCODE    = p_barcode
         AND organization_id = p_org
         AND rownum          = 1;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           lvl_cnt := 0;
   END;


   IF lvl_cnt = 0
   THEN
      RETURN 'NOTFOUND';
   ELSE
      RETURN 'EXISTS';
   END IF;

EXCEPTION
   WHEN OTHERS THEN
        raise_application_error (-20003, SQLERRM);
END;
