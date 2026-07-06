TRIGGER "INFINITY21_JSMES"."TRG_MAT_SCRAP_RECEIPT_INS" 
 AFTER
  INSERT
 ON im_item_scrap_receipt
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
        FROM im_item_scrap_inventory
       WHERE item_code = :NEW.item_code
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

      INSERT INTO im_item_scrap_inventory
                  (item_code,
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
           VALUES (:NEW.item_code,
                   'G',
                   :NEW.organization_id,
                   :NEW.line_type,
                   'W',
                   0,
                   :NEW.receipt_qty,
                   0 * :NEW.receipt_qty,
                   '*',
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
        FROM im_item_scrap_inventory
       WHERE item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_scrap_inventory
         SET inventory_qty =   NVL (inventory_qty, 0)
                             + :NEW.receipt_qty,
             inventory_amt =   NVL (inventory_amt, 0)
                             + :NEW.receipt_qty * 0
       WHERE item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_scrap_inventory
         SET inventory_price =
                   DECODE (inventory_qty, 0, 0, inventory_amt / inventory_qty)
       WHERE item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;