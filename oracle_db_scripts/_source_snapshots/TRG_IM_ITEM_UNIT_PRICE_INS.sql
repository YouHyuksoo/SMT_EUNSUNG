TRIGGER "INFINITY21_JSMES"."TRG_IM_ITEM_UNIT_PRICE_INS" 
 BEFORE
  INSERT
 ON im_item_unit_price
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO lvi_count
     FROM im_item_receipt
    WHERE supplier_code = :NEW.supplier_code
      AND item_code = :NEW.item_code
      AND line_type = :NEW.line_type
      AND receipt_date >= :NEW.dateset
      AND receipt_date <= TRUNC (SYSDATE)
      AND organization_id = :NEW.organization_id;

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
       WHERE supplier_code = :NEW.supplier_code
         AND item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND receipt_date >= :NEW.dateset
         AND receipt_date <= TRUNC (SYSDATE)
         AND organization_id = :NEW.organization_id;
   END IF;

   
-----------------------------------------------------------
--
-----------------------------------------------------------

   UPDATE im_item_unit_price
      SET dateend =   :NEW.dateset  - 1
    WHERE supplier_code = :NEW.supplier_code
      AND item_code = :NEW.item_code
      
 --     AND CURRENCY  = :NEW.CURRENCY
      AND line_type = :NEW.line_type
      AND dateset <= :NEW.dateset
      AND dateend >= :NEW.dateset
      AND organization_id = :NEW.organization_id;
      
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;