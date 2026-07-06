CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_CHECK_VENDOR_LOTNO_BLOKING
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
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_ITEM_CODE  (IN, VARCHAR2) - 품목 코드
   *   P_LOT_NO  (IN, VARCHAR2) - LOT 번호
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_SUPPLIER_LOT_BLOKING - 공급사 / LOT 관련 값 조회 또는 참조
   *   IM_ITEM_RECEIPT_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 0회
   *   DML: SELECT 3회
   * ================================================================
   * 사용 예시:
   *   SELECT F_CHECK_VENDOR_LOTNO_BLOKING(...) FROM DUAL;
   * ================================================================ */
 "F_CHECK_VENDOR_LOTNO_BLOKING" (
   P_MODEL_NAME   IN VARCHAR2,
   P_ITEM_CODE    IN VARCHAR2,
   P_LOT_NO       IN VARCHAR2)
   RETURN NUMBER
IS
   LVI_COUNT          NUMBER;
   LVI_ITEM_CHECK     NUMBER;
   LVS_VENDOR_LOTNO   VARCHAR2 (50);
BEGIN
   --------------------------------------------
   -- ？？？？？？？？？？ ？？？？？？ u？？
   --------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO LVI_ITEM_CHECK
        FROM IQ_SUPPLIER_LOT_BLOKING
       WHERE MODEL_NAME = P_MODEL_NAME AND ITEM_CODE = P_ITEM_CODE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;


   IF NVL (LVI_ITEM_CHECK, 0) = 0
   THEN
      RETURN 0;
   END IF;

   --------------------------------------------
   -- ？？？？？？？？？？ ？？？？？？ ？？？？？？ ？？？？？？？？？？
   -- ？？？？ ？？？？？？？？？？ ？？？？？？？？？？？？？？？？
   --------------------------------------------

   BEGIN
      SELECT VENDOR_LOTNO
        INTO LVS_VENDOR_LOTNO
        FROM IM_ITEM_RECEIPT_BARCODE
       WHERE LOT_NO = P_LOT_NO;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;


   IF NVL (LVS_VENDOR_LOTNO, '*') = '*'
   THEN
      RETURN 110; --？？？？？？？？ o？？？？
   END IF;


   --------------------------------------------
   --  ？？？？？？？？？？？？？？ ？？？？ ？？？？？？？？？ u？？
   --
   --------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IQ_SUPPLIER_LOT_BLOKING
       WHERE MODEL_NAME = P_MODEL_NAME AND ITEM_CODE = P_ITEM_CODE
             AND UPPER(VENDOR_LOTNO)  = SUBSTR (UPPER(LVS_VENDOR_LOTNO), 1, LENGTH (VENDOR_LOTNO))
             AND ROWNUM = 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 120;
   END;

   -------------------------------------
   --  ？？？？？？？？？？K
   -------------------------------------
   IF NVL(LVI_COUNT,0)  > 0
   THEN
      RETURN 0;
   ELSE
      RETURN 130;
   END IF;
----------------------------------------------------------------
--
----------------------------------------------------------------
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 140;
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END;
