CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IM_ITEM_UNIT_PRICE_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_UNIT_PRICE 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_UNIT_PRICE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.SUPPLIER_CODE - 신규/변경 후 공급사 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.LINE_TYPE - 신규/변경 후 라인 관련 값
   *   :NEW.DATESET - 신규/변경 후 값 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.UNIT_PRICE - 신규/변경 후 단가 관련 값
   *   :NEW.CURRENCY - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_RECEIPT - 품목 / 입고 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_UNIT_PRICE - 품목 / 단가 관련 트리거 대상 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_LOCAL_CURRENCY - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IM_ITEM_UNIT_PRICE_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IM_ITEM_UNIT_PRICE_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IM_ITEM_UNIT_PRICE_INS" 
 BEFORE
  INSERT
 ON im_item_unit_price
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO lvi_count
     FROM im_item_receipt
    WHERE supplier_code = :NEW.supplier_code
      AND item_code = :NEW.item_code
      AND line_type = :NEW.line_type
      AND receipt_date >= :NEW.dateset
      AND receipt_date <= TRUNC (SYSDATE)
      AND organization_id = :NEW.organization_id;

   IF lvi_count > 0
   THEN
      UPDATE im_item_receipt
         SET unit_price = :NEW.unit_price,
             receipt_amt = receipt_qty * :NEW.unit_price * exchange_rate,
             foreign_receipt_amt =
                   DECODE (
                      currency,
                      f_get_local_currency (organization_id), 0,
                      receipt_qty * :NEW.unit_price
                   ),
             currency = :NEW.currency
       WHERE supplier_code = :NEW.supplier_code
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND receipt_date >= :NEW.dateset
         AND receipt_date <= TRUNC (SYSDATE)
         AND organization_id = :NEW.organization_id;
   END IF;

   
-----------------------------------------------------------
--
-----------------------------------------------------------

   UPDATE im_item_unit_price
      SET dateend =   :NEW.dateset  - 1
    WHERE supplier_code = :NEW.supplier_code
      AND item_code = :NEW.item_code
      
 --     AND CURRENCY  = :NEW.CURRENCY
      AND line_type = :NEW.line_type
      AND dateset <= :NEW.dateset
      AND dateend >= :NEW.dateset
      AND organization_id = :NEW.organization_id;
      
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
