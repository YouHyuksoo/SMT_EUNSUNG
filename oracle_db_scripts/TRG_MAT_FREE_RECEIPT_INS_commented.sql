CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"."TRG_MAT_FREE_RECEIPT_INS" 
 AFTER
  INSERT
 ON im_item_free_receipt
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt   NUMBER := 0;
BEGIN
    /* ================================================================
     * 트리거명  : TRG_MAT_FREE_RECEIPT_INS
     * 작성일  : 2026-07-02
     * 수정이력: 2026-07-02 - AI(Codex) - 한글 주석 자동 추가
     * ================================================================
     * [AI 분석] 기능 설명:
     *   IM_ITEM_FREE_RECEIPT 테이블의 INSERT 이벤트 발생 시 원본 로직에 정의된 자동 처리를 수행한다.
     * ================================================================
     * [AI 분석] 발화 조건:
     *   시점/단위: AFTER EACH ROW / 이벤트: INSERT / 조건: 없음
     * ================================================================
     * [AI 분석] 대상 객체:
     *   IM_ITEM_FREE_RECEIPT - 트리거가 걸린 테이블/뷰
     * ================================================================
     * [AI 분석] OLD/NEW 사용:
     *   :NEW - SUPPLIER_CODE, ITEM_CODE, LINE_TYPE, MATERIAL_MFS, ORGANIZATION_ID, RECEIPT_PRICE, RECEIPT_QTY, RECEIPT_AMT, ENTER_BY, LAST_MODIFY_BY 변경 후 값 참조
     * ================================================================
     * [AI 분석] 예외 처리:
     *   원본 EXCEPTION 블록 기준으로 오류를 처리한다.
     * ================================================================
     * [AI 분석] 복잡도:
     *   조건 분기: IF 4회 / 반복문: 0회 / DML: SELECT 1회, INSERT 5회, UPDATE 2회
     * ================================================================
     * 검증 방법: USER_OBJECTS, USER_ERRORS, USER_SOURCE, USER_TRIGGERS 조회만 사용한다.
     * 주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
     * ================================================================ */

   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM im_item_free_inventory
       WHERE supplier_code = :NEW.supplier_code
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND material_mfs = :NEW.material_mfs
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      INSERT INTO im_item_free_inventory
                  (supplier_code,
                   item_code,
                   material_mfs,
                   organization_id,
                   line_type,
                   inventory_price,
                   inventory_qty,
                   inventory_amt,
                   last_receipt_date,
                   last_issue_date,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (:NEW.supplier_code,
                   :NEW.item_code,
                   :NEW.material_mfs,
                   :NEW.organization_id,
                   :NEW.line_type,
                   :NEW.receipt_price,
                   :NEW.receipt_qty,
                   :NEW.receipt_amt,
                   TRUNC (SYSDATE),
                   NULL,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   ELSE
      UPDATE im_item_free_inventory
         SET inventory_qty =   NVL (inventory_qty, 0)
                             + :NEW.receipt_qty,
             inventory_amt =   NVL (inventory_amt, 0)
                             + :NEW.receipt_amt
       WHERE item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND material_mfs = :NEW.material_mfs
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_free_inventory
         SET inventory_price = DECODE (
                                  inventory_qty,
                                  0, 0,
                                  NVL (inventory_amt, 0) / inventory_qty
                               )
       WHERE item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND material_mfs = :NEW.material_mfs
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;
   END IF;

   
--------------------------------------------------------------
-- Material  , Assembly , Product
--------------------------------------------------------------

   IF f_get_item_division (
         :NEW.item_code,
         TRUNC (SYSDATE),
         :NEW.organization_id
      ) IN ('F', 'G')
   THEN
      INSERT INTO ip_product_issue
                  (issue_date,
                   issue_sequence,
                   organization_id,
                   work_order_no,
                   mfs,
                   item_code,
                   item_type,
                   product_line_type,
                   line_code,
                   workstage_code,
                   machine_code,
                   issue_type,
                   issue_account,
                   issue_deficit,
                   issue_price,
                   currency,
                   issue_qty,
                   issue_amt,
                   issue_status,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date
                  )
           VALUES (TRUNC (SYSDATE),
                   :NEW.receipt_sequence,
                   :NEW.organization_id,
                   :NEW.work_order_no,
                   :NEW.mfs,
                   :NEW.item_code,
                   DECODE (:NEW.item_type, NULL, 'M', :NEW.item_type),
                   :NEW.line_type,
                   'SUBLET',
                   'SUBLET',
                   '*',
                   'N',
                   'M003',
                   DECODE (:NEW.receipt_deficit, '1', '3', '4'), --ISSUE_DEFICIT,
                   :NEW.receipt_price, --ISSUE_PRICE,
                   DECODE (:NEW.currency, NULL, 'CNY', :NEW.currency),
                   :NEW.receipt_qty, --ISSUE_QTY,
                   :NEW.receipt_amt,
                   :NEW.receipt_status,
                   :NEW.enter_by,
                   SYSDATE, --ENTER_DATE,
                   :NEW.last_modify_by,
                   SYSDATE
                  );
   ELSIF f_get_item_division (
            :NEW.item_code,
            TRUNC (SYSDATE),
            :NEW.organization_id
         ) = 'W'
   THEN
      -- assembly item


      INSERT INTO ip_assembly_issue
                  (issue_date,
                   issue_sequence,
                   organization_id,
                   work_order_no,
                   mfs,
                   material_mfs,
                   item_code,
                   item_type,
                   product_line_type,
                   line_code,
                   workstage_code,
                   machine_code,
                   issue_type,
                   issue_account,
                   issue_deficit,
                   issue_price,
                   currency,
                   issue_qty,
                   issue_amt,
                   issue_status,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date
                  )
           VALUES (TRUNC (SYSDATE),
                   :NEW.receipt_sequence,
                   :NEW.organization_id,
                   :NEW.work_order_no,
                   :NEW.mfs,
                   :NEW.material_mfs,
                   :NEW.item_code,
                   DECODE (:NEW.item_type, NULL, 'M', :NEW.item_type),
                   :NEW.line_type,
                   'SUBLET',
                   'SUBLET',
                   '*',
                   'N',
                   'M003',
                   DECODE (:NEW.receipt_deficit, '1', '3', '4'), --ISSUE_DEFICIT,
                   :NEW.receipt_price, --ISSUE_PRICE,
                   DECODE (:NEW.currency, NULL, 'CNY', :NEW.currency),
                   :NEW.receipt_qty, --ISSUE_QTY,
                   :NEW.receipt_amt,
                   :NEW.receipt_status,
                   :NEW.enter_by,
                   SYSDATE, --ENTER_DATE,
                   :NEW.last_modify_by,
                   SYSDATE
                  );
   ELSE
      -- Material item

      INSERT INTO im_item_issue
                  (issue_date,
                   issue_sequence,
                   organization_id,
                   material_mfs,
                   mfs,
                   item_code,
                   parent_item_code,
                   location_code,
                   item_type,
                   line_code,
                   workstage_code,
                   issue_deficit,
                   issue_qty,
                   issue_status,
                   issue_amt,
                   issue_account,
                   line_type,
                   comments,
                   issue_price,
                   issue_type,
                   supplier_code,
                   work_order_no,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (:NEW.receipt_date,
                   :NEW.receipt_sequence,
                   :NEW.organization_id,
                   :NEW.material_mfs,
                   :NEW.mfs,
                   :NEW.item_code,
                   :NEW.parent_item_code,
                   :NEW.LOCATION_CODE, --LOCATION_CODE,
                   DECODE (:NEW.item_type, NULL, 'M', :NEW.item_type), --ITEM_TYPE,
                   'SUBLET', --:NEW.LINE_CODE,
                   'SUBLET', --WORKSTAGE_CODE,
                   DECODE (:NEW.receipt_deficit, '1', '3', '4'), --ISSUE_DEFICIT,
                   :NEW.receipt_qty, --ISSUE_QTY,
                   :NEW.receipt_status,
                   :NEW.receipt_amt, --ISSUE_AMT,
                   'M003', --ISSUE_ACCOUNT,
                   :NEW.line_type,
                   '*', --COMMENTS,
                   :NEW.receipt_price, --ISSUE_PRICE,
                   
--                   DECODE(:NEW.CURRENCY , NULL , 'CNY',:NEW.CURRENCY ) ,
                   'N', --ISSUE_TYPE,
                   :NEW.supplier_code,
                   :NEW.work_order_no,
                   SYSDATE, --ENTER_DATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   END IF;
--------------------------------------------------------------

EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
