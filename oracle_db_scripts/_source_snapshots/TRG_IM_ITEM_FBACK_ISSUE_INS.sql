TRIGGER "INFINITY21_JSMES"."TRG_IM_ITEM_FBACK_ISSUE_INS" 
 BEFORE
  INSERT
 ON im_item_fback_issue
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
      raise_application_error (
         -20003,
            :NEW.material_mfs
         || '  '
         || :NEW.item_code
         || '  '
         || :NEW.line_type
         || 'Inventory Not Found '
         || SQLERRM
      );
   ELSE
      SELECT inventory_qty, inventory_price,
             DECODE (NVL (inventory_qty, 0), 0, 0, inventory_amt)
        INTO lvf_last_inventory_qty, lvf_last_avg_price,
             lvf_last_inventory_amt
        FROM im_item_fback_inventory
       WHERE material_mfs = :NEW.material_mfs
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_fback_inventory
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
--
-------------------------------------------------------
   IF :NEW.issue_type = 'N'
   THEN
      
---------------------------------------------------------------------------
      IF :NEW.issue_account = 'M010' --fback
      THEN
         
---------------------------------------------------------------------------
         IF :NEW.issue_deficit = '4'
         THEN
            UPDATE im_item_workstage_receipt
               SET receipt_status = 'C'
             WHERE mfs = :NEW.mfs
               AND work_order_no = :NEW.work_order_no
               AND workstage_code = :NEW.workstage_code
               AND item_code = :NEW.item_code
               AND line_type = :NEW.line_type
               AND receipt_status = 'N'
               AND organization_id = :NEW.organization_id;
         END IF;

         INSERT INTO im_item_workstage_receipt
                     (receipt_date,
                      receipt_sequence,
                      organization_id,
                      workstage_code,
                      from_workstage_code,
                      machine_code,
                      material_mfs,
                      mfs,
                      item_code,
                      item_type,
                      line_type,
                      line_code,
                      receipt_deficit,
                      receipt_price,
                      receipt_qty,
                      receipt_weight,
                      receipt_amt,
                      receipt_type,
                      receipt_account,
                      item_unit_weight,
                      issue_date,
                      issue_sequence,
                      work_order_no,
                      receipt_status,
                      transfer_date,
                      transfer_sequence,
                      transfer_type,
                      invoice_no,
                      enter_date,
                      enter_by,
                      last_modify_date,
                      last_modify_by
                     )
              VALUES (:NEW.issue_date,
                      seq_workstage_receipt_seq.NEXTVAL,
                      :NEW.organization_id,
                      :NEW.workstage_code,
                      'WH',
                      :NEW.machine_code,
                      :NEW.material_mfs,
                      :NEW.mfs,
                      :NEW.item_code,
                      :NEW.item_type,
                      :NEW.line_type,
                      :NEW.line_code,
                      DECODE (:NEW.issue_deficit, '3', '1', '4', '2'),
                      :NEW.issue_price,
                      :NEW.issue_qty,
                      :NEW.issue_qty, --RECEIPT_WEIGHT,
                      :NEW.issue_amt,
                      :NEW.issue_type, --RECEIPT_TYPE,AUTO / NORMAL
                      :NEW.issue_account,
                      0, --ITEM_UNIT_WEIGHT,
                      NULL, --ISSUE_DATE,
                      NULL, --ISSUE_SEQUENCE,
                      :NEW.work_order_no,
                      :NEW.issue_status, --RECEIPT_STATUS,
                      :NEW.issue_date, --ISSUE_DATE,
                      seq_workstage_receipt_seq.NEXTVAL, --TRANSFER_SEQUENCE,
                      'S',
                      :NEW.invoice_no,
                      SYSDATE,
                      :NEW.enter_by,
                      SYSDATE,
                      :NEW.last_modify_by
                     );
      
---------------------------------------------------------------------

      END IF;
   END IF;

   UPDATE im_item_work_order
      SET issue_qty =   NVL (issue_qty, 0)
                      + :NEW.issue_qty
    WHERE work_order_no = :NEW.work_order_no
      AND mfs = :NEW.mfs
      AND item_code = :NEW.item_code
      AND parent_item_code = :NEW.parent_item_code
      AND organization_id = :NEW.organization_id;
-------------------------------------------------------

EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20003,
            'Phase = '
         || TO_CHAR (phase)
         || '  '
         || SQLERRM
      );
END;