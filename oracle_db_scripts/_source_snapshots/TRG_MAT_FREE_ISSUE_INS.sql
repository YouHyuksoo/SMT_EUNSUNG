TRIGGER "INFINITY21_JSMES"."TRG_MAT_FREE_ISSUE_INS" 
 AFTER
  INSERT
 ON im_item_free_issue
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt   NUMBER := 0;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM im_item_free_inventory
       WHERE supplier_code = :NEW.supplier_code
         AND item_code = :NEW.item_code
         AND material_mfs = :NEW.material_mfs
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
                   :NEW.issue_price,
                   :NEW.issue_qty * -1,
                   :NEW.issue_amt * -1,
                   NULL,
                   TRUNC (SYSDATE),
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   ELSE
      UPDATE im_item_free_inventory
         SET inventory_qty =   NVL (inventory_qty, 0)
                             - :NEW.issue_qty,
             inventory_amt =   NVL (inventory_amt, 0)
                             - :NEW.issue_amt
       WHERE item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND material_mfs = :NEW.material_mfs
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_free_inventory
         SET inventory_price =
                   DECODE (inventory_qty, 0, 0, inventory_amt / inventory_qty)
       WHERE item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND material_mfs = :NEW.material_mfs
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;