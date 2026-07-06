TRIGGER "INFINITY21_JSMES"."TRG_IM_ITEM_SALE_RECEIPT_INS" 
 BEFORE
  INSERT
 ON im_item_sale_receipt
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt   NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM im_item_sale_inventory
       WHERE supplier_code = :NEW.supplier_code
         AND item_code = :NEW.item_code
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      INSERT INTO im_item_sale_inventory
                  (supplier_code,
                   item_code,
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
      UPDATE im_item_sale_inventory
         SET inventory_qty =   NVL (inventory_qty, 0)
                             + :NEW.receipt_qty,
             inventory_amt =   NVL (inventory_amt, 0)
                             + :NEW.receipt_amt
       WHERE item_code = :NEW.item_code
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_sale_inventory
         SET inventory_price = DECODE (
                                  inventory_qty,
                                  0, 0,
                                  NVL (inventory_amt, 0) / inventory_qty
                               )
       WHERE item_code = :NEW.item_code
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;
   END IF;

   INSERT INTO im_item_issue
               (issue_date,
                issue_sequence,
                organization_id,
                mfs,
                material_mfs,
                item_code,
                location_code,
                item_type,
                line_code,
                workstage_code,
                issue_deficit,
                issue_qty,
                issue_status,
                issue_price,
                issue_amt,
                issue_account,
                line_type,
                comments,
                sale_amt,
                sale_price,
                invoice_no,
                issue_type,
                supplier_code,
                work_order_no,
                interface_yn,
                enter_date,
                enter_by,
                last_modify_date,
                last_modify_by
               )
        VALUES (:NEW.receipt_date,
                :NEW.receipt_sequence,
                :NEW.organization_id,
                '*', --MFS,
                :NEW.material_mfs,
                :NEW.item_code,
                :NEW.LOCATION_CODE, --LOCATION_CODE,
                'S', --ITEM_TYPE,
                'SALE', --:NEW.LINE_CODE,
                '*', --WORKSTAGE_CODE,
                DECODE (:NEW.receipt_deficit, '1', '3', '4'), --ISSUE_DEFICIT,
                :NEW.receipt_qty, --ISSUE_QTY,
                :NEW.receipt_status, --ISSUE_STATUS,
                f_get_mat_issue_price (
                   :NEW.material_mfs,
                   :NEW.item_code,
                   :NEW.line_type,
                   :NEW.organization_id
                ),
                  f_get_mat_issue_price (
                   :NEW.material_mfs,
                   :NEW.item_code,
                   :NEW.line_type,
                   :NEW.organization_id
                )
                * :NEW.receipt_qty,
                'M004', --ISSUE_ACCOUNT,
                :NEW.line_type,
                '*', --COMMENTS,
                :NEW.receipt_price, --SALE_PRICE,
                :NEW.receipt_amt, --SALE_AMT,
                :NEW.invoice_no,
                'N', --ISSUE_TYPE,
                :NEW.supplier_code,
                '*', --WORK_ORDER_NO,
                'N',
                SYSDATE, --ENTER_DATE,
                :NEW.enter_by,
                SYSDATE,
                :NEW.last_modify_by
               );
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;