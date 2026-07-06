CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_MAT_FBACK_RECEIPT_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_FBACK_RECEIPT 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_FBACK_RECEIPT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.MATERIAL_MFS - 신규/변경 후 자재 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.LINE_TYPE - 신규/변경 후 라인 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.UNIT_PRICE - 신규/변경 후 단가 관련 값
   *   :NEW.RECEIPT_QTY - 신규/변경 후 입고 / 수량 관련 값
   *   :NEW.EXCHANGE_RATE - 신규/변경 후 율 관련 값
   *   :NEW.MATERIAL_COST_AMT - 신규/변경 후 자재 관련 값
   *   :NEW.LOCATION_CODE - 신규/변경 후 값 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :NEW.RECEIPT_DATE - 신규/변경 후 입고 / 일자 관련 값
   *   :NEW.MFS - 신규/변경 후 값 값
   *   :NEW.RECEIPT_DEFICIT - 신규/변경 후 입고 관련 값
   *   :NEW.RECEIPT_AMT - 신규/변경 후 입고 관련 값
   *   :NEW.MATERIAL_COST - 신규/변경 후 자재 관련 값
   *   :NEW.SUPPLIER_CODE - 신규/변경 후 공급사 관련 값
   *   :NEW.CURRENCY - 신규/변경 후 값 값
   *   :NEW.ENTER_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.LAST_MODIFY_DATE - 신규/변경 후 일자 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_FBACK_RECEIPT - 품목 / 입고 관련 트리거 대상 테이블
   *   IM_ITEM_FBACK_INVENTORY - 품목 / 재고 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_ARRIVAL - 품목 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_LEDGER - 품목 / 수불장 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 4회, UPDATE 4회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_MAT_FBACK_RECEIPT_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_MAT_FBACK_RECEIPT_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_MAT_FBACK_RECEIPT_INS" 
 AFTER
  INSERT
 ON im_item_fback_receipt
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt                     NUMBER := 0;
   lvi_return                  NUMBER;
   lvf_last_dd_avg_price       NUMBER;
   lvf_last_dd_inventory_qty   NUMBER;
   lvf_last_dd_inventory_amt   NUMBER;
   lvf_arrival_qty             NUMBER;
   lvf_arrival_amt             NUMBER;
   lvf_mm_receipt_qty          NUMBER;
   lvf_mm_receipt_amt          NUMBER;
   lvf_mm_issue_qty            NUMBER;
   lvf_mm_issue_amt            NUMBER;
   lvf_mm_free_issue_qty       NUMBER;
   lvf_mm_free_issue_amt       NUMBER;
   lvf_last_inventory_qty      NUMBER;
   lvf_last_avg_price          NUMBER;
   lvf_last_inventory_amt      NUMBER;
BEGIN
   
-------------------------------------
-- current inventory get
-------------------------------------



   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM im_item_fback_inventory
       WHERE material_mfs = :NEW.material_mfs
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      lvf_last_inventory_qty := 0;
      lvf_last_avg_price := 0;
      lvf_last_inventory_amt := 0;

      INSERT INTO im_item_fback_inventory
                  (material_mfs,
                   item_code,
                   inventory_status,
                   organization_id,
                   line_type,
                   inventory_hold,
                   inventory_price,
                   inventory_qty,
                   inventory_amt,
                   location_code,
                   comments,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (:NEW.material_mfs,
                   :NEW.item_code,
                   'G',
                   :NEW.organization_id,
                   :NEW.line_type,
                   'W',
                   :NEW.unit_price,
                   :NEW.receipt_qty,
                     (:NEW.exchange_rate * :NEW.unit_price * :NEW.receipt_qty)
                   + NVL (:NEW.material_cost_amt, 0),
                   :NEW.location_code,
                   NULL,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   ELSE
      SELECT inventory_qty, inventory_price,
             inventory_amt
        INTO lvf_last_inventory_qty, lvf_last_avg_price,
             lvf_last_inventory_amt
        FROM im_item_fback_inventory
       WHERE material_mfs = :NEW.material_mfs
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_fback_inventory
         SET inventory_qty =   NVL (inventory_qty, 0)
                             + :NEW.receipt_qty,
             inventory_amt =   NVL (inventory_amt, 0)
                             + (  :NEW.receipt_qty
                                * :NEW.unit_price
                                * :NEW.exchange_rate
                               )
                             + NVL (:NEW.material_cost_amt, 0),
             location_code = :NEW.location_code
       WHERE material_mfs = :NEW.material_mfs
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_fback_inventory
         SET inventory_price =
                   DECODE (inventory_qty, 0, 0, inventory_amt / inventory_qty)
       WHERE material_mfs = :NEW.material_mfs
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;
   END IF;

   
----------------------------------------------------
-- ITEM LEDGER INSERT
----------------------------------------------------

   INSERT INTO im_item_ledger
               (close_yyyymm,
                receipt_issue_sequence,
                organization_id,
                material_mfs,
                mfs,
                item_code,
                line_type,
                last_inventory_qty,
                last_avg_price,
                last_inventory_amt,
                receipt_account,
                receipt_deficit,
                receipt_date,
                receipt_qty,
                receipt_price,
                receipt_amt,
                issue_account,
                issue_date,
                issue_deficit,
                issue_qty,
                issue_price,
                issue_amt,
                inventory_qty,
                material_cost,
                material_cost_amt,
                supplier_code,
                workstage_code,
                currency,
                enter_by,
                enter_date,
                last_modify_by,
                last_modify_date
               )
        VALUES (TO_CHAR (:NEW.receipt_date, 'YYYYMM'),
                seq_mat_ledger_sequence.NEXTVAL,
                :NEW.organization_id,
                :NEW.material_mfs,
                :NEW.mfs,
                :NEW.item_code,
                :NEW.line_type,
                lvf_last_inventory_qty,
                lvf_last_avg_price,
                lvf_last_inventory_amt,
                '', --RECEIPT_ACCOUNT,
                :NEW.receipt_deficit,
                :NEW.receipt_date,
                :NEW.receipt_qty,
                :NEW.unit_price,
                :NEW.receipt_amt,
                '', --ISSUE_ACCOUNT,
                NULL, --ISSUE_DATE,
                '', --ISSUE_DEFICIT,
                0, -- ISSUE_QTY,
                0, -- ISSUE_PRICE,
                0, -- ISSUE_AMT,
                  lvf_last_inventory_qty
                + :NEW.receipt_qty, -- INVENTORY_QTY,
                :NEW.material_cost,
                :NEW.material_cost_amt,
                :NEW.supplier_code,
                '', -- WORKSTAGE_CODE,
                :NEW.currency,
                :NEW.enter_by,
                :NEW.enter_date,
                :NEW.last_modify_by,
                :NEW.last_modify_date
               );

   
----------------------------------------------------
-- ARRIVAL STATUS CHANGE
----------------------------------------------------

   IF :NEW.receipt_status = 'C'
   THEN
      UPDATE im_item_arrival
         SET arrival_type = 'A',
             receipt_date = NULL,
             receipt_sequence = NULL
       WHERE arrival_date = :NEW.arrival_date
         AND arrival_seq_no = :NEW.arrival_seq_no
         AND organization_id = :NEW.organization_id;
   ELSE
      UPDATE im_item_arrival
         SET arrival_type = 'R',
             receipt_date = :NEW.receipt_date,
             receipt_sequence = :NEW.receipt_sequence
       WHERE arrival_date = :NEW.arrival_date
         AND arrival_seq_no = :NEW.arrival_seq_no
         AND organization_id = :NEW.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
