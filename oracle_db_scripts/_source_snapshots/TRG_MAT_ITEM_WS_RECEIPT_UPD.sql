TRIGGER "INFINITY21_JSMES"."TRG_MAT_ITEM_WS_RECEIPT_UPD" 
 BEFORE
   UPDATE OF receipt_qty
 ON im_item_workstage_receipt
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt      NUMBER;
   lvi_return   NUMBER;
BEGIN
   
-----------------------------------------------
--
-----------------------------------------------

   UPDATE im_item_workstage_inventory
      SET inventory_qty =   NVL (inventory_qty, 0)
                          + (  NVL (:NEW.receipt_qty, 0)
                             - NVL (:OLD.receipt_qty, 0)
                            )
    WHERE item_code = :OLD.item_code
      AND organization_id = :OLD.organization_id;

-------------------------------------------------------------
--
-------------------------------------------------------------
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;