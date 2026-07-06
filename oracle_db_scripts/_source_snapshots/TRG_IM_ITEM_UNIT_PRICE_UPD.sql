TRIGGER "INFINITY21_JSMES"."TRG_IM_ITEM_UNIT_PRICE_UPD" 
 BEFORE
   UPDATE OF dateset, unit_price, currency
 ON im_item_unit_price
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO lvi_count
     FROM im_item_receipt
    WHERE supplier_code = :OLD.supplier_code
      AND item_code = :OLD.item_code
      AND line_type = :OLD.line_type
      AND receipt_date >= NVL (:NEW.dateset, :OLD.dateset)
      AND receipt_date <= TRUNC (SYSDATE)
      AND 
--          unit_price = :OLD.unit_price                    AND
          organization_id = :OLD.organization_id;

   IF lvi_count > 0
   THEN
      UPDATE im_item_receipt
         SET unit_price = :NEW.unit_price,
             receipt_amt = receipt_qty * :NEW.unit_price * exchange_rate,
             foreign_receipt_amt =
                   DECODE (
                      currency,
                      f_get_local_currency (organization_id), 0,
                      receipt_qty * :NEW.unit_price
                   ),
             currency = :NEW.currency
       WHERE supplier_code = :OLD.supplier_code
         AND item_code = :OLD.item_code
         AND line_type = :OLD.line_type
         AND receipt_date >= NVL (:NEW.dateset, :OLD.dateset)
         AND receipt_date <= TRUNC (SYSDATE)
         AND 
--             unit_price = :OLD.unit_price                    AND
             organization_id = :OLD.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;