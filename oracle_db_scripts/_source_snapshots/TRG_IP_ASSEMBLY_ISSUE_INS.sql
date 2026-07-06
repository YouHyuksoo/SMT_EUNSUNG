TRIGGER "INFINITY21_JSMES"."TRG_IP_ASSEMBLY_ISSUE_INS" 
 AFTER
  INSERT
 ON ip_assembly_issue
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt                     NUMBER       := 0;
   lvs_currency                VARCHAR2 (3);
   lvf_last_dd_avg_price       NUMBER       := 0;
   lvf_last_dd_inventory_qty   NUMBER       := 0;
   lvf_last_dd_inventory_amt   NUMBER       := 0;
   lvf_mm_shipping_qty         NUMBER       := 0;
   lvf_mm_shipping_amt         NUMBER       := 0;
   lvf_mm_receipt_qty          NUMBER       := 0;
   lvf_mm_receipt_amt          NUMBER       := 0;
   phase                       NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM is_assembly_inventory
       WHERE item_code = :NEW.item_code
         AND mfs = :NEW.mfs
         AND product_line_type = :NEW.product_line_type
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
         -20007,
        'MFS='||:NEW.mfs||' ITEM CODE='||:NEW.item_code||' LINE TYPE='||:NEW.product_line_type||' not exists in inventory'
      );
   END IF;

   UPDATE is_assembly_inventory
      SET inventory_qty =   NVL (inventory_qty, 0)
                          - :NEW.issue_qty,
          inventory_amt =   NVL (inventory_amt, 0)
                          - :NEW.issue_amt,
          last_issue_date = SYSDATE
    WHERE item_code = :NEW.item_code
      AND mfs = :NEW.mfs
      AND product_line_type = :NEW.product_line_type
      AND organization_id = :NEW.organization_id;


-------------------------------------------------------
-- Workstage Inventory
-------------------------------------------------------

   IF :NEW.issue_account = 'M001'
   THEN
      /*     BEGIN
              SELECT COUNT(*)
              INTO   lvl_cnt
              FROM   im_item_workstage_inventory
              WHERE  line_code = :NEW.line_code             AND
                     workstage_code = :NEW.workstage_code   AND
                     item_code = :NEW.item_code             AND
                     mfs = :NEW.mfs                         AND
                     organization_id = :NEW.organization_id AND
                     ROWNUM = 1;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 lvl_cnt := 0;
           END;

           IF lvl_cnt < 1
           THEN
              INSERT INTO im_item_workstage_inventory
                          (line_code,
                           workstage_code,
                           machine_code,
                           item_code,
                           mfs,
                           inventory_status,
                           organization_id,
                           line_type,
                           inventory_hold,
                           inventory_price,
                           inventory_qty,
                           inventory_amt,
                           enter_date,
                           enter_by,
                           last_modify_date,
                           last_modify_by
                          )
                   VALUES (:NEW.line_code,
                           :NEW.workstage_code,
                           :NEW.machine_code,
                           :NEW.item_code,
                           :NEW.mfs,
                           'G',
                           :NEW.organization_id,
                           :NEW.product_line_type,
                           'W',
                           :NEW.issue_price,
                           :NEW.issue_qty,
                           :NEW.issue_price * :NEW.issue_qty,
                           SYSDATE,
                           :NEW.enter_by,
                           SYSDATE,
                           :NEW.last_modify_by
                          );
           ELSE
              UPDATE im_item_workstage_inventory
                 SET inventory_qty = NVL(inventory_qty, 0) + :NEW.issue_qty,
                     inventory_amt =
                         NVL(inventory_amt, 0)
                         + (:NEW.issue_qty * :NEW.issue_price)
               WHERE line_code = :NEW.line_code             AND
                     workstage_code = :NEW.workstage_code   AND
                     item_code = :NEW.item_code             AND
                     mfs = :NEW.mfs                         AND
                     organization_id = :NEW.organization_id;
           END IF;*/

      IF :NEW.issue_deficit = '4'
      THEN
         UPDATE im_item_workstage_receipt
            SET receipt_status = 'C'
          WHERE mfs = :NEW.mfs
            AND work_order_no = :NEW.work_order_no
            AND workstage_code = :NEW.workstage_code
            AND item_code = :NEW.item_code
            AND line_type = :NEW.product_line_type
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
                   :NEW.product_line_type,
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
                   'C',
                   '', --:NEW.invoice_no,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   ELSIF :NEW.issue_account = 'M012'
   THEN

----------------------------------------------------
-- SERVICE INSERT
----------------------------------------------------
      IF :NEW.issue_deficit = '4'
      THEN
         UPDATE is_product_svc_receipt
            SET receipt_status = 'C'
          WHERE product_date = :NEW.issue_date
            AND product_sequence = :NEW.issue_sequence
            AND receipt_status = 'N'
            AND organization_id = :NEW.organization_id;
      END IF;

      INSERT INTO is_product_svc_receipt
                  (receipt_date,
                   receipt_sequence,
                   organization_id,
                   mfs,
                   supplier_code,
                   item_code,
                   product_line_type,
                   receipt_qty,
                   receipt_price,
                   currency,
                   receipt_amt,
                   foreign_receipt_amt,
                   receipt_account,
                   receipt_deficit,
                   work_division,
                   line_code,
                   receipt_type,
                   product_date,
                   product_sequence,
                   lqc_inspect_no,
                   oqc_inspect_no,
                   exchange_rate,
                   confirm_date,
                   confirm_by,
                   confirm_yn,
                   receipt_status,
                   comments,
                   enter_by,
                   enter_date,
                   last_modify_date,
                   last_modify_by,
                   location_code,
                   interface_yn,
                   interface_date,
                   interface_work_no,
                   workstage_code,
                   machine_code,
                   order_no,
                   material_mfs,
                   origin_mfs
                  )
           VALUES (TRUNC (SYSDATE), --RECEIPT_DATE,
                   seq_product_receipt.NEXTVAL, --RECEIPT_SEQUENCE,
                   :NEW.organization_id,
                   :NEW.mfs,
                   NULL, --:NEW.supplier_code,
                   :NEW.item_code,
                   :NEW.product_line_type, --PRODUCT_LINE_TYPE,
                   :NEW.issue_qty, --RECEIPT_QTY,
                   :NEW.issue_price, --RECEIPT_PRICE,
                   :NEW.currency,
                   :NEW.issue_amt, --RECEIPT_AMT,
                   0, --FOREIGN_RECEIPT_AMT,
                   'M012', --RECEIPT_ACCOUNT,
                   DECODE (:NEW.issue_deficit, 3, 1, 4, 2), --RECEIPT_DEFICIT,
                   'P', --WORK_DIVISION,
                   :NEW.line_code,
                   'N', --RECEIPT_TYPE,
                   :NEW.issue_date, --PRODUCT_DATE,
                   :NEW.issue_sequence, --PRODUCT_SEQUENCE,
                   NULL, --LQC_INSPECT_NO,
                   NULL, --OQC_INSPECT_NO,
                   1, --EXCHANGE_RATE,
                   NULL, --CONFIRM_DATE,
                   NULL, --CONFIRM_BY,
                   'N', --CONFIRM_YN,
                   :NEW.issue_status, --RECEIPT_STATUS,
                   '', --COMMENTS,
                   :NEW.enter_by,
                   SYSDATE, --ENTER_DATE,
                   SYSDATE, --LAST_MODIFY_DATE,
                   :NEW.last_modify_by,
                   NULL, --LOCATION_CODE,
                   'N', --INTERFACE_YN,
                   NULL, --INTERFACE_DATE,
                   NULL, --INTERFACE_WORK_NO,
                   :NEW.workstage_code,
                   :NEW.machine_code,
                   NULL, --ORDER_NO,
                   NULL, --material_mfs,
                   NULL --ORIGIN_MFS
                  );
   END IF;


-----------------------------------------------
--
-----------------------------------------------
   UPDATE im_item_work_order
      SET issue_qty =   NVL (issue_qty, 0)
                      + :NEW.issue_qty
    WHERE work_order_no = :NEW.work_order_no
--      AND mfs = :NEW.mfs
      AND item_code = :NEW.item_code
      AND line_type = :NEW.product_line_type

--      AND parent_item_code = :NEW.parent_item_code
      AND organization_id = :NEW.organization_id;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;