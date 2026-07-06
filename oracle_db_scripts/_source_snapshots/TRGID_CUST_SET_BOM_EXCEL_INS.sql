TRIGGER "INFINITY21_JSMES"."TRGID_CUST_SET_BOM_EXCEL_INS" 
 BEFORE
  INSERT
 ON id_customer_set_bom_excel
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO lvi_count
     FROM id_customer_set_bom
    WHERE customer_code = :NEW.customer_code
      AND set_item_code = :NEW.set_item_code
      AND item_code = :NEW.item_code
      AND dateset <= :NEW.dateset
      AND dateset >= :NEW.dateset
      AND organization_id = :NEW.organization_id;

   IF lvi_count > 0
   THEN
      :NEW.upload_yn := 'E'; --EXISTS
   ELSE
      :NEW.upload_yn := 'Y'; --EXISTS

      INSERT INTO id_customer_set_bom
                  (customer_code,
                   set_item_code,
                   organization_id,
                   item_code,
                   set_item_name,
                   set_item_spec,
                   set_item_uom,
                   model_unit_qty,
                   dateset,
                   dateend,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   order_rate,
                   set_item_group,
                   set_item_class
                  )
           VALUES (:NEW.customer_code,
                   :NEW.set_item_code,
                   :NEW.organization_id,
                   :NEW.item_code,
                   :NEW.set_item_name,
                   :NEW.set_item_spec,
                   :NEW.set_item_uom,
                   :NEW.model_unit_qty,
                   :NEW.dateset,
                   :NEW.dateend,
                   SYSDATE,
                   'SYSTEM',
                   SYSDATE,
                   'SYSTEM',
                   :NEW.order_rate,
                   :NEW.set_item_group,
                   :NEW.set_item_class
                  );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;