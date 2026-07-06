TRIGGER "INFINITY21_JSMES"."TRG_IS_PRODUCT_SALE_PRICE_UPD" 
 BEFORE
   UPDATE OF dateset, product_sale_price, sale_currency
 ON is_product_sale_price
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
--   SELECT COUNT (*)
--     INTO lvi_count
--     FROM is_product_shipping
--    WHERE customer_code = :OLD.customer_code
--      AND item_code = :OLD.item_code
--      AND product_line_type = :OLD.product_line_type
--      AND shipping_date >= NVL (:NEW.dateset, :OLD.dateset)
--      AND shipping_date <= TRUNC (SYSDATE)
--      AND 
----          unit_price = :OLD.unit_price                    AND
--          organization_id = :OLD.organization_id;
--
--   IF lvi_count > 0
--   THEN
--      UPDATE is_product_shipping
--         SET product_sale_price = :NEW.product_sale_price,
--             shipping_amt =
--                        shipping_qty * :NEW.product_sale_price * exchange_rate,
--             foreign_shipping_amt =
--                   DECODE (
--                      sale_currency,
--                      f_get_local_currency (organization_id), 0,
--                      shipping_qty * :NEW.product_sale_price
--                   ),
--             sale_currency = :NEW.sale_currency
--       WHERE customer_code = :OLD.customer_code
--         AND item_code = :OLD.item_code
--         AND product_line_type = :OLD.product_line_type
--         AND shipping_date >= NVL (:NEW.dateset, :OLD.dateset)
--         AND shipping_date <= TRUNC (SYSDATE)
--         AND 
----             unit_price = :OLD.unit_price                    AND
--             organization_id = :OLD.organization_id;
--   END IF;
NULL;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;