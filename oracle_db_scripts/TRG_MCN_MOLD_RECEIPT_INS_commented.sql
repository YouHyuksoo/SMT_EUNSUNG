CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_MCN_MOLD_RECEIPT_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IMCN_MOLD_RECEIPT 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IMCN_MOLD_RECEIPT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.MOLD_CODE - 신규/변경 후 값 값
   *   :NEW.MOLD_VERSION - 신규/변경 후 값 값
   *   :NEW.MOLD_SET_SERIAL - 신규/변경 후 시리얼 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.LINE_TYPE - 신규/변경 후 라인 관련 값
   *   :NEW.RECEIPT_QTY - 신규/변경 후 입고 / 수량 관련 값
   *   :NEW.UNIT_PRICE - 신규/변경 후 단가 관련 값
   *   :NEW.RECEIPT_AMT - 신규/변경 후 입고 관련 값
   *   :NEW.SUPPLIER_CODE - 신규/변경 후 공급사 관련 값
   *   :NEW.MOLD_VERSION_SPEC - 신규/변경 후 값 값
   *   :NEW.ORDER_NO - 신규/변경 후 값 값
   *   :NEW.LOCATION_CODE - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_MOLD_RECEIPT - 입고 관련 트리거 대상 테이블
   *   IMCN_MOLD_INVENTORY - 재고 관련 트리거 내부 SQL에서 참조/변경
   *   IMCN_MOLD_PURCHASE_ORDER - 업무 데이터 트리거 내부 SQL에서 참조/변경
   *   IMCN_MOLD_LOCATION - 업무 데이터 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 2회, UPDATE 5회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_MCN_MOLD_RECEIPT_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_MCN_MOLD_RECEIPT_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_MCN_MOLD_RECEIPT_INS" 
 AFTER
  INSERT
 ON imcn_mold_receipt
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt                     NUMBER := 0;
   lvi_count                   NUMBER := 0;
   lvi_return                  NUMBER;
   lvf_last_dd_avg_price       NUMBER;
   lvf_last_dd_inventory_qty   NUMBER;
   lvf_last_dd_inventory_amt   NUMBER;
   lvf_mm_receipt_qty          NUMBER;
   lvf_mm_receipt_amt          NUMBER;
   lvf_mm_issue_qty            NUMBER;
   lvf_mm_issue_amt            NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM imcn_mold_inventory
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      INSERT INTO imcn_mold_inventory
                  (mold_code, line_type, mold_version,
                   mold_set_serial, mold_use_status, inventory_qty,
                   inventory_price, inventory_amt, organization_id,
                   enter_date, enter_by, last_modify_date, last_modify_by,
                   mold_warehouse_code, break_value, actual_value,
                   location_code, line_code, workstage_code, machine_code,
                   last_receipt_date, mold_in_out, mold_set_qty,
                   supplier_code, mold_version_spec,
                   barcode
                  )
           VALUES (:NEW.mold_code, :NEW.line_type, :NEW.mold_version,
                   :NEW.mold_set_serial, 'U', :NEW.receipt_qty,
                   :NEW.unit_price, :NEW.receipt_amt, :NEW.organization_id,
                   SYSDATE, 'SYSTEM', SYSDATE, 'SYSTEM',
                   '*', 0, 0,
                   '*', '*', '*', '*',
                   SYSDATE, 'I', 1,
                   :NEW.supplier_code, :NEW.mold_version_spec,
                   :NEW.mold_code 
--                   :NEW.mold_code || :NEW.mold_version || :NEW.mold_set_serial
                  );
   ELSE
      UPDATE imcn_mold_inventory
         SET inventory_qty = NVL (inventory_qty, 0) + :NEW.receipt_qty,
             inventory_amt = inventory_amt + :NEW.receipt_amt,
             last_receipt_date = SYSDATE,
             mold_use_status = 'U'
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id;

      UPDATE imcn_mold_inventory
         SET inventory_price =
                 DECODE (inventory_qty,
                         0, 0,
                         (inventory_amt / inventory_qty)
                        )
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id;
   END IF;

----------------------------------------------------
-- PURCHASE ORDER UPDATE
----------------------------------------------------
   UPDATE imcn_mold_purchase_order
      SET receipt_qty = NVL (receipt_qty, 0) + :NEW.receipt_qty
    WHERE order_no = :NEW.order_no AND organization_id = :NEW.organization_id;

-------------------------------------------------
--
-------------------------------------------------
   UPDATE imcn_mold_location
      SET mold_code = :NEW.mold_code,
          mold_version = :NEW.mold_version,
          mold_set_serial = :NEW.mold_set_serial,
          mold_location_status = 'I'
    WHERE mold_location_code = :NEW.location_code
      AND organization_id = :NEW.organization_id;
      
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
