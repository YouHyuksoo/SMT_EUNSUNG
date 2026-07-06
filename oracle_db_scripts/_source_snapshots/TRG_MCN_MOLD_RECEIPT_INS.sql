TRIGGER "INFINITY21_JSMES"."TRG_MCN_MOLD_RECEIPT_INS" 
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