TRIGGER "INFINITY21_JSMES"."TRGIP_PRODUCT_RUN_CARD_IO_INS" 
 BEFORE
  INSERT
 ON ip_product_run_card_io
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvi_count   NUMBER;
BEGIN
    BEGIN
        SELECT   COUNT ( * )
          INTO   lvi_count
          FROM   ip_product_run_card_inv
         WHERE   line_code = :new.line_code
             AND workstage_code = :new.workstage_code
             AND model_name = :new.model_name
             AND model_suffix = :new.model_suffix
             AND pcb_item = :new.pcb_item
             AND organization_id = :new.organization_id;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvi_count := 0;
    END;

    IF lvi_count = 0
    THEN
        INSERT INTO ip_product_run_card_inv (item_code,
                                             model_name,
                                             model_suffix,
                                             line_code,
                                             workstage_code,
                                             inventory_qty,
                                             organization_id,
                                             enter_date,
                                             enter_by,
                                             last_modify_date,
                                             last_modify_by,
                                             pcb_item)
          VALUES   (:new.item_code,
                    :new.model_name,
                    :new.model_suffix,
                    :new.line_code,
                    :new.workstage_code,
                    :new.lot_qty,
                    :new.organization_id,
                    SYSDATE,
                    :new.enter_by,
                    SYSDATE,
                    :new.last_modify_by,
                    :new.pcb_item);
    ELSE
        UPDATE   ip_product_run_card_inv
           SET   inventory_qty = inventory_qty + :new.lot_qty
         WHERE   line_code = :new.line_code
             AND workstage_code = :new.workstage_code
             AND model_name = :new.model_name
             AND model_suffix = :new.model_suffix
             AND pcb_item = :new.pcb_item
             AND organization_id = :new.organization_id;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;