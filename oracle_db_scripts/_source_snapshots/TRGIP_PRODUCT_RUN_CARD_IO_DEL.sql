TRIGGER "INFINITY21_JSMES"."TRGIP_PRODUCT_RUN_CARD_IO_DEL" 
 BEFORE
  DELETE
 ON ip_product_run_card_io
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN


      UPDATE   ip_product_run_card_inv
           SET   inventory_qty = inventory_qty - :old.lot_qty
         WHERE   line_code = :old.line_code
             AND workstage_code = :old.workstage_code
             AND model_name = :old.model_name
             AND model_suffix = :old.model_suffix
             AND pcb_item = :old.pcb_item
             AND organization_id = :old.organization_id;


END ;