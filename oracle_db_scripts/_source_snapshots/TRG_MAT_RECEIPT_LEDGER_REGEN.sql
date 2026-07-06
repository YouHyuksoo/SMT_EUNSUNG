TRIGGER "INFINITY21_JSMES"."TRG_MAT_RECEIPT_LEDGER_REGEN" 
 BEFORE
  INSERT
 ON im_item_receipt_ledger_regen
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
        FROM im_item_inventory_ledger_regen
       WHERE material_mfs = :NEW.material_mfs
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_inventory_ledger_regen
         SET inventory_qty =   NVL (inventory_qty, 0)
                             + :NEW.receipt_qty,
             inventory_amt =   NVL (inventory_amt, 0)
                             + (  :NEW.receipt_qty
                                * :NEW.unit_price
                                * :NEW.exchange_rate
                               )
                             + NVL (:NEW.material_cost_amt, 0)
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
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;