TRIGGER "INFINITY21_JSMES"."TRG_MAT_SCRAP_ISSUE_INS" 
 AFTER
  INSERT
 ON im_item_scrap_issue
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
      raise_application_error (-20003,    'Inventory Not Found '
                                       || SQLERRM);
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
                             - :NEW.issue_qty,
             inventory_amt =   NVL (inventory_amt, 0)
                             - 0
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
      raise_application_error (
         -20003,
            'Phase = '
         || TO_CHAR (phase)
         || '  '
         || SQLERRM
      );
END;