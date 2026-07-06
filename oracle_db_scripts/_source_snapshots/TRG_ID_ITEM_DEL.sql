TRIGGER "INFINITY21_JSMES"."TRG_ID_ITEM_DEL" 
 AFTER
  DELETE
 ON id_item
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   INSERT INTO id_item_history
               (item_code,
                dateset,
                organization_id,
                item_class,
                item_spec,
                item_uom,
                item_type,
                virtual_receipt_yn,
                item_name,
                line_type,
                route_no,
                barcode,
                abc_grade,
                raw_material,
                safety_inventory,
                work_bad_rate,
                transfer_uom,
                manufacture_leadtime,
                order_cycle,
                order_rule,
                svc_code,
                capacity,
                LENGTH,
                dateend,
                set_item_yn,
                special_property,
                layer,
                part_no,
                height,
                weight,
                drawing_no,
                gradient,
                density,
                item_division,
                issue_packing_qty,
                inner_diameter,
                outer_diameter,
                width,
                hs_code,
                hs_name,
                hs_spec,
                hs_code_scrap,
                hs_name_scrap,
                hs_spec_scrap,
                enter_by,
                enter_date,
                last_modify_by,
                last_modify_date,
                transfer_yn,
                line_code,
                tariff_rate,
                supplier_code,
                customer_code,
                model_name,
                model_suffix
               )
        VALUES (:OLD.item_code,
                :OLD.dateset,
                :OLD.organization_id,
                :OLD.item_class,
                :OLD.item_spec,
                :OLD.item_uom,
                :OLD.item_type,
                :OLD.virtual_receipt_yn,
                :OLD.item_name,
                :OLD.line_type,
                :OLD.route_no,
                :OLD.barcode,
                :OLD.abc_grade,
                :OLD.raw_material,
                :OLD.safety_inventory,
                :OLD.work_bad_rate,
                :OLD.transfer_uom,
                :OLD.manufacture_leadtime,
                :OLD.order_cycle,
                :OLD.order_rule,
                :OLD.svc_code,
                :OLD.capacity,
                :OLD.LENGTH,
                :OLD.dateend,
                :OLD.set_item_yn,
                :OLD.special_property,
                :OLD.layer,
                :OLD.part_no,
                :OLD.height,
                :OLD.weight,
                :OLD.drawing_no,
                :OLD.gradient,
                :OLD.density,
                :OLD.item_division,
                :OLD.issue_packing_qty,
                :OLD.inner_diameter,
                :OLD.outer_diameter,
                :OLD.width,
                :OLD.hs_code,
                :OLD.hs_name,
                :OLD.hs_spec,
                :OLD.hs_code_scrap,
                :OLD.hs_name_scrap,
                :OLD.hs_spec_scrap,
                :OLD.enter_by,
                :OLD.enter_date,
                :OLD.last_modify_by,
                :OLD.last_modify_date,
                :OLD.transfer_yn,
                :OLD.line_code,
                :OLD.tariff_rate,
                :OLD.supplier_code,
                :OLD.customer_code,
                :OLD.model_name,
                :OLD.model_suffix
               );

   
--------------------------------------------------
-- ITEM MASTER DELETE
--------------------------------------------------
   DELETE FROM im_item_master
         WHERE supplier_code = '*'
           AND item_code = :OLD.item_code
           AND organization_id = :OLD.organization_id;

   
--------------------------------------------------
-- BUY PRICE DELETE
--------------------------------------------------

   DELETE FROM im_item_unit_price
         WHERE supplier_code = '*'
           AND item_code = :OLD.item_code
           AND organization_id = :OLD.organization_id;

   
----------------------------------------------------
---- SALE PRICE DELETE
----------------------------------------------------
--
--   DELETE FROM is_product_sale_price
--         WHERE customer_code = '*'
--           AND item_code = :OLD.item_code
--           AND organization_id = :OLD.organization_id;
--
--   
----------------------------------------------------
---- SALE PRICE DELETE
----------------------------------------------------
--
--   DELETE FROM is_product_work_cost
--         WHERE customer_code = '*'
--           AND item_code = :OLD.item_code
--           AND organization_id = :OLD.organization_id;
--
--   
----------------------------------------------------
---- svc SALE PRICE DELETE
----------------------------------------------------
--
--   DELETE FROM is_svc_sale_price
--         WHERE customer_code = '*'
--           AND item_code = :OLD.item_code
--           AND organization_id = :OLD.organization_id;
END;