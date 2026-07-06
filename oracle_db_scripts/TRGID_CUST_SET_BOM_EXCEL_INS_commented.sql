CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGID_CUST_SET_BOM_EXCEL_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ID_CUSTOMER_SET_BOM_EXCEL 테이블에 엑셀 업로드 데이터가 반영될 때 기준정보 또는 BOM 관련 후속 처리를 수행한다.
   *   업로드 원천 데이터를 업무 테이블 구조에 맞춰 검증/전개하는 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ID_CUSTOMER_SET_BOM_EXCEL - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.CUSTOMER_CODE - 신규/변경 후 고객 관련 값
   *   :NEW.SET_ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.DATESET - 신규/변경 후 값 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.UPLOAD_YN - 신규/변경 후 값 값
   *   :NEW.SET_ITEM_NAME - 신규/변경 후 품목 / 명칭 관련 값
   *   :NEW.SET_ITEM_SPEC - 신규/변경 후 품목 관련 값
   *   :NEW.SET_ITEM_UOM - 신규/변경 후 품목 관련 값
   *   :NEW.MODEL_UNIT_QTY - 신규/변경 후 모델 / 수량 관련 값
   *   :NEW.DATEEND - 신규/변경 후 값 값
   *   :NEW.ORDER_RATE - 신규/변경 후 율 관련 값
   *   :NEW.SET_ITEM_GROUP - 신규/변경 후 품목 관련 값
   *   :NEW.SET_ITEM_CLASS - 신규/변경 후 품목 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_CUSTOMER_SET_BOM_EXCEL - 고객 / BOM / 엑셀 관련 트리거 대상 테이블
   *   ID_CUSTOMER_SET_BOM - 고객 / BOM 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGID_CUST_SET_BOM_EXCEL_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGID_CUST_SET_BOM_EXCEL_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGID_CUST_SET_BOM_EXCEL_INS" 
 BEFORE
  INSERT
 ON id_customer_set_bom_excel
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO lvi_count
     FROM id_customer_set_bom
    WHERE customer_code = :NEW.customer_code
      AND set_item_code = :NEW.set_item_code
      AND item_code = :NEW.item_code
      AND dateset <= :NEW.dateset
      AND dateset >= :NEW.dateset
      AND organization_id = :NEW.organization_id;

   IF lvi_count > 0
   THEN
      :NEW.upload_yn := 'E'; --EXISTS
   ELSE
      :NEW.upload_yn := 'Y'; --EXISTS

      INSERT INTO id_customer_set_bom
                  (customer_code,
                   set_item_code,
                   organization_id,
                   item_code,
                   set_item_name,
                   set_item_spec,
                   set_item_uom,
                   model_unit_qty,
                   dateset,
                   dateend,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   order_rate,
                   set_item_group,
                   set_item_class
                  )
           VALUES (:NEW.customer_code,
                   :NEW.set_item_code,
                   :NEW.organization_id,
                   :NEW.item_code,
                   :NEW.set_item_name,
                   :NEW.set_item_spec,
                   :NEW.set_item_uom,
                   :NEW.model_unit_qty,
                   :NEW.dateset,
                   :NEW.dateend,
                   SYSDATE,
                   'SYSTEM',
                   SYSDATE,
                   'SYSTEM',
                   :NEW.order_rate,
                   :NEW.set_item_group,
                   :NEW.set_item_class
                  );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
