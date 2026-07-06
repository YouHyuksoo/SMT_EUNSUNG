TRIGGER "INFINITY21_JSMES"."TRG_IS_PRODUCT_SALE_PRICE_INS" 
 BEFORE
  INSERT
 ON is_product_sale_price
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
--   SELECT COUNT (*)
--     INTO lvi_count
--     FROM is_product_shipping
--    WHERE customer_code = :NEW.customer_code
--      AND item_code = :NEW.item_code
--      AND product_line_type = :NEW.product_line_type
--      AND shipping_date >= :NEW.dateset
--      AND shipping_date <= TRUNC (SYSDATE)
--      AND organization_id = :NEW.organization_id;
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
--       WHERE customer_code = :NEW.customer_code
--         AND item_code = :NEW.item_code
--         AND product_line_type = :NEW.product_line_type
--         AND shipping_date >= :NEW.dateset
--         AND shipping_date <= TRUNC (SYSDATE)
--         AND organization_id = :NEW.organization_id;
--   END IF;
--
------------------------------------------------------------------
----
------------------------------------------------------------------
-- lvi_count := 0;
--
--   BEGIN
--      SELECT COUNT (*)
--        INTO lvi_count
--        FROM is_product_receipt
--       WHERE item_code = :NEW.item_code
--         AND product_line_type = :NEW.product_line_type
--         AND receipt_date >= :NEW.dateset
--         AND receipt_date <= :NEW.dateend
--         AND organization_id = :NEW.organization_id;
--   EXCEPTION
--      WHEN NO_DATA_FOUND
--      THEN
--         lvi_count := 0;
--   END;
--
--   IF lvi_count > 0
--   THEN
--      UPDATE is_product_receipt
--         SET receipt_price = :NEW.product_sale_price,
--             receipt_amt =
--                          receipt_qty * :NEW.product_sale_price
--                          * exchange_rate
--       WHERE item_code = :NEW.item_code
--         AND product_line_type = :NEW.product_line_type
--         AND receipt_date >= :NEW.dateset
--         AND receipt_date <= :NEW.dateend
--         AND organization_id = :NEW.organization_id;
--   END IF;
--   
--------------------------------------------------------------



   UPDATE is_product_sale_price
      SET dateend =   :NEW.dateset - 1
    WHERE customer_code = :NEW.customer_code
      AND item_code = :NEW.item_code
      AND product_line_type = :NEW.product_line_type
       AND dateset <= :NEW.dateset
      AND dateend >= :NEW.dateset
      AND organization_id = :NEW.organization_id;
      
--      update is_product_inventory
--      set inventory_price = :NEW.product_sale_price
--    where item_code = :NEW.item_code
--      and product_line_type = :NEW.product_line_type
--      AND organization_id = :NEW.organization_id;
--
--   update is_product_inventory
--      set inventory_amt = inventory_qty * :NEW.product_sale_price
--    where item_code = :NEW.item_code
--      and product_line_type = :NEW.product_line_type
--      and organization_id = :NEW.organization_id;

EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;