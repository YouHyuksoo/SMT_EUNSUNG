TRIGGER "INFINITY21_JSMES"."TRG_ID_ITEM_UPD" 
 BEFORE
   UPDATE OF supplier_code, line_type, customer_code
 ON id_item
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   IF :NEW.line_type = 'M'
   THEN
      UPDATE id_eng_bom
         SET line_type = 'M'
       WHERE child_item_code = :OLD.item_code
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;

      UPDATE id_eng_bom
         SET item_type = 'M'
       WHERE parent_item_code = :OLD.item_code
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;
   ELSIF :NEW.line_type = 'T'
   THEN
      UPDATE id_eng_bom
         SET line_type = 'T'
       WHERE child_item_code = :OLD.item_code
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;

      UPDATE id_eng_bom
         SET item_type = 'T'
       WHERE parent_item_code = :OLD.item_code
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;
   END IF;

   
-------------------------------------------------------
--
-------------------------------------------------------

   IF      :OLD.supplier_code = '*'
       AND :NEW.supplier_code <> '*'
   THEN
      UPDATE im_item_master
         SET supplier_code = :NEW.supplier_code
       WHERE item_code = :OLD.item_code
         AND supplier_code = '*'
         AND organization_id = :OLD.organization_id;

      UPDATE im_item_unit_price
         SET supplier_code = :NEW.supplier_code
       WHERE item_code = :OLD.item_code
         AND supplier_code = '*'
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;

--      UPDATE is_product_buy_price
--         SET supplier_code = :NEW.supplier_code
--       WHERE item_code = :OLD.item_code
--         AND supplier_code = '*'
--         AND organization_id = :OLD.organization_id;
   END IF;

   
-------------------------------------------------------
--
-------------------------------------------------------

--   IF      :OLD.customer_code = '*'
--       AND :NEW.customer_code <> '*'
--   THEN
--      UPDATE is_product_sale_price
--         SET customer_code = :NEW.customer_code
--       WHERE item_code = :OLD.item_code
--         AND customer_code = '*'
--         AND organization_id = :OLD.organization_id;
--
--      UPDATE is_material_sale_price
--         SET customer_code = :NEW.customer_code
--       WHERE item_code = :OLD.item_code
--         AND customer_code = '*'
--         AND organization_id = :OLD.organization_id;
--   END IF;
END;