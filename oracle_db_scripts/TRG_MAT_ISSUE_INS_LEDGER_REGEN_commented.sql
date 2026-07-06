CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_MAT_ISSUE_INS_LEDGER_REGEN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_ISSUE_LEDGER_REGEN 테이블의 INSERT 발생 시 재고/수불 관련 후속 데이터를 자동 정리한다.
   *   입출고, 재고 수량, 수불장 연계 값을 일관되게 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_ISSUE_LEDGER_REGEN - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.MATERIAL_MFS - 신규/변경 후 자재 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.LINE_TYPE - 신규/변경 후 라인 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.ISSUE_QTY - 신규/변경 후 출고 / 수량 관련 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :NEW.ISSUE_AMT - 신규/변경 후 출고 관련 값
   *   :NEW.ISSUE_DATE - 신규/변경 후 출고 / 일자 관련 값
   *   :NEW.MFS - 신규/변경 후 값 값
   *   :NEW.ISSUE_ACCOUNT - 신규/변경 후 출고 관련 값
   *   :NEW.ISSUE_DEFICIT - 신규/변경 후 출고 관련 값
   *   :NEW.ISSUE_PRICE - 신규/변경 후 출고 / 단가 관련 값
   *   :NEW.WORKSTAGE_CODE - 신규/변경 후 공정 관련 값
   *   :NEW.ENTER_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.LAST_MODIFY_DATE - 신규/변경 후 일자 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_ISSUE_LEDGER_REGEN - 품목 / 출고 / 수불장 관련 트리거 대상 테이블
   *   IM_ITEM_INVENTORY_LEDGER_REGEN - 품목 / 재고 / 수불장 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_LEDGER - 품목 / 수불장 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 4회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_MAT_ISSUE_INS_LEDGER_REGEN';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_MAT_ISSUE_INS_LEDGER_REGEN';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_MAT_ISSUE_INS_LEDGER_REGEN" 
 BEFORE
  INSERT
 ON im_item_issue_ledger_regen
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt                     NUMBER       := 0;
   lvs_currency                VARCHAR2 (3);
   lvs_local_currency          VARCHAR2 (3);
   lvf_exchange_rate           NUMBER       := 0;
   lvf_unit_price              NUMBER       := 0;
   lvs_delivery                VARCHAR (10);
   lvi_count                   NUMBER       := 0;
   lvf_last_dd_avg_price       NUMBER       := 0;
   lvf_last_dd_inventory_qty   NUMBER       := 0;
   lvf_last_dd_inventory_amt   NUMBER       := 0;
   lvf_arrival_qty             NUMBER       := 0;
   lvf_arrival_amt             NUMBER       := 0;
   lvf_mm_issue_qty            NUMBER       := 0;
   lvf_mm_issue_amt            NUMBER       := 0;
   lvf_mm_receipt_qty          NUMBER       := 0;
   lvf_mm_receipt_amt          NUMBER       := 0;
   lvf_mm_free_issue_qty       NUMBER       := 0;
   lvf_mm_free_issue_amt       NUMBER       := 0;
   lvf_last_inventory_qty      NUMBER       := 0;
   lvf_last_avg_price          NUMBER       := 0;
   lvf_last_inventory_amt      NUMBER       := 0;
   phase                       NUMBER       := 0;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM im_item_inventory_ledger_regen
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

      INSERT INTO im_item_inventory_ledger_regen
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
                   0,
                   :NEW.issue_qty,
                   0,
                   '*',
                   NULL,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   
--      raise_application_error(
--         -20003, :NEW.material_mfs || '  ' || :NEW.item_code || '  '
--                 || :NEW.line_type || 'Inventory Not Found ' || SQLERRM
--      );
   ELSE
      SELECT inventory_qty, inventory_price,
             DECODE (NVL (inventory_qty, 0), 0, 0, inventory_amt)
        INTO lvf_last_inventory_qty, lvf_last_avg_price,
             lvf_last_inventory_amt
        FROM im_item_inventory_ledger_regen
       WHERE material_mfs = :NEW.material_mfs
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_inventory_ledger_regen
         SET inventory_qty =   NVL (inventory_qty, 0)
                             - :NEW.issue_qty,
             inventory_amt =   DECODE (
                                NVL (inventory_qty, 0),
                                0, 0,
                                NVL (inventory_amt, 0)
                             )
                             - :NEW.issue_amt
       WHERE material_mfs = :NEW.material_mfs
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_inventory_ledger_regen
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
                mfs,
                material_mfs,
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
        VALUES (TO_CHAR (:NEW.issue_date, 'YYYYMM'),
                seq_mat_ledger_sequence.NEXTVAL,
                :NEW.organization_id,
                :NEW.mfs,
                :NEW.material_mfs,
                :NEW.item_code,
                :NEW.line_type,
                lvf_last_inventory_qty,
                lvf_last_avg_price,
                lvf_last_inventory_amt,
                '', --RECEIPT_ACCOUNT,
                '', --:NEW.receipt_deficit,
                NULL, --receipt_date,
                0, --:NEW.receipt_qty,
                0, --:NEW.unit_price,
                0, --:NEW.receipt_amt,
                :NEW.issue_account,
                :NEW.issue_date,
                :NEW.issue_deficit,
                :NEW.issue_qty,
                :NEW.issue_price,
                :NEW.issue_amt,
                  lvf_last_inventory_qty
                - :NEW.issue_qty, -- INVENTORY_QTY,
                0,
                0,
                '', --supplier_code,
                :NEW.workstage_code,
                '', --currency,
                :NEW.enter_by,
                :NEW.enter_date,
                :NEW.last_modify_by,
                :NEW.last_modify_date
               );
-------------------------------------------------------

EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         SQLCODE,
            'Phase = '
         || TO_CHAR (phase)
         || '  '
         || SQLERRM
      );
END;
