TRIGGER "INFINITY21_JSMES"."TRG_ID_ITEM_INS"
 AFTER
  INSERT
 ON id_item
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
   
-----------------------------------------------------
--
--  Check System Condition
--
-----------------------------------------------------
   IF      :NEW.item_division = 'F'
       AND :NEW.line_code IS NULL
   THEN
      raise_application_error (-20003,    'Line Code Invalid'
                                       || SQLERRM);
   END IF;

   IF :NEW.line_type = 'N'
   THEN
      NULL;
   ELSE
      
------------------------------------------------------
-- New Material Insert
------------------------------------------------------
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_master
       WHERE item_code = :NEW.item_code
         AND organization_id = :NEW.organization_id;

      IF lvi_count > 0
      THEN
         NULL;
      ELSE
         IF :NEW.line_type = 'T'
         THEN
            NULL;
         ELSE
            INSERT INTO im_item_master
                        (supplier_code,
                         item_code,
                         dateset,
                         organization_id,
                         order_type,
                         order_rate,
                         order_leadtime,
                         order_bad_rate,
                         mim_order_qty,
                         packing_qty,
                         longterm_delivery_yn,
                         warehouse_charge,
                         order_charge,
                         dateend,
                         main_vendor_yn,
                         payment_type,
                         inspect_method,
                         inspect_rule,
                         incidental_expense_code,
                         enter_by,
                         enter_date,
                         last_modify_by,
                         last_modify_date
                        )
                 VALUES (NVL (:NEW.supplier_code, '*'), --SUPPLIER_CODE,
                         :NEW.item_code,
                         :NEW.dateset,
                         :NEW.organization_id,
                         'A', --ORDER_TYPE,
                         100, --ORDER_RATE,
                         0, --ORDER_LEADTIME,
                         0, --ORDER_BAD_RATE,
                         0, --MIM_ORDER_QTY,
                         0, --PACKING_QTY,
                         'N', --LONGTERM_DELIVERY_YN,
                         '*', --WAREHOUSE_CHARGE,
                         '*', --ORDER_CHARGE,
                         :NEW.dateend,
                         'Y', --MAIN_VENDOR_YN,
                         '*', --PAYMENT_TYPE,
                         'S', --INSPECT_METHOD,
                         'I', --INSPECT_RULE,
                         '*', --INCIDENTAL_EXPENSE_CODE,
                         :NEW.enter_by,
                         :NEW.enter_date,
                         :NEW.last_modify_by,
                         :NEW.last_modify_date
                        );
         END IF;
      END IF;

      IF :NEW.line_type = 'T'
      THEN
         NULL;
      ELSE
         
------------------------------------------------------
-- New Material Buy Price Insert
------------------------------------------------------
  --       SELECT COUNT (*)
 --         INTO lvi_count
  --        FROM im_item_unit_price
  --        WHERE item_code = :NEW.item_code
  --         AND line_type = :NEW.line_type
   --         AND organization_id = :NEW.organization_id;


      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_unit_price
       WHERE item_code = :NEW.item_code
         AND supplier_code = NVL (:NEW.supplier_code, '*')
         AND organization_id = :NEW.organization_id;
         
      IF ( lvi_count = 0 ) THEN
         
         
         INSERT INTO im_item_unit_price
                     (dateset,
                      item_code,
                      supplier_code,
                      line_type,
                      organization_id,
                      delivery,
                      currency,
                      unit_price,
                      tax_rate,
                      price_type,
                      approval_no,
                      standard_unit_price,
                      dateend,
                      price_change_reason,
                      confirm_by,
                      price_change_confirm_yn,
                      confirm_date,
                      enter_date,
                      enter_by,
                      last_modify_date,
                      last_modify_by
                     )
              VALUES (:NEW.dateset,
                      :NEW.item_code,
                      NVL (:NEW.supplier_code, '*'), --SUPPLIER_CODE,
                      :NEW.line_type,
                      :NEW.organization_id,
                      '2', --DELIVERY, ( 1 EXPORT ,2 DOMESTIC )
                      f_get_local_currency (:NEW.organization_id), --CURRENCY,
                      NVL (:NEW.buy_price, 0), --UNIT_PRICE,
                      0, --TAX_RATE,
                      'T', --PRICE_TYPE,
                      '', --APPROVAL_NO,
                      NVL (:NEW.buy_price, 0), --STANDARD_UNIT_PRICE,
                      :NEW.dateend,
                      'N', --PRICE_CHANGE_REASON,
                      '', --CONFIRM_BY,
                      'N', --PRICE_CHANGE_CONFIRM_YN,
                      NULL, --CONFIRM_DATE,
                      :NEW.enter_date,
                      :NEW.enter_by,
                      :NEW.last_modify_date,
                      :NEW.last_modify_by
                     );
                     
      END IF;
                     
                     
      END IF;

--      IF :NEW.svc_code = 'Y'
--      THEN
--         INSERT INTO is_svc_sale_price
--                     (dateset,
--                      item_code,
--                      customer_code,
--                      line_type,
--                      organization_id,
--                      delivery,
--                      sale_currency,
--                      sale_price,
--                      price_type,
--                      approval_no,
--                      standard_sale_price,
--                      dateend,
--                      price_change_reason,
--                      confirm_by,
--                      price_change_confirm_yn,
--                      confirm_date,
--                      enter_date,
--                      enter_by,
--                      last_modify_date,
--                      last_modify_by
--                     )
--              VALUES (:NEW.dateset,
--                      :NEW.item_code,
--                      NVL (:NEW.supplier_code, '*'), --SUPPLIER_CODE,
--                      :NEW.line_type,
--                      :NEW.organization_id,
--                      '2', --DELIVERY, ( 1 EXPORT ,2 DOMESTIC )
--                      f_get_local_currency (:NEW.organization_id), --CURRENCY,
--                      0, --UNIT_PRICE,
--                      'T', --PRICE_TYPE,
--                      '', --APPROVAL_NO,
--                      0, --STANDARD_UNIT_PRICE,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_REASON,
--                      '', --CONFIRM_BY,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      NULL, --CONFIRM_DATE,
--                      :NEW.enter_date,
--                      :NEW.enter_by,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by
--                     );
--      END IF;

      
-- ------------------------------------------------------
---- New Product Sale Price Insert
--------------------------------------------------------
--      IF :NEW.item_division = 'F'
--      THEN
--         INSERT INTO is_product_sale_price
--                     (customer_code,
--                      item_code,
--                      product_line_type,
--                      dateset,
--                      organization_id,
--                      confirm_date,
--                      price_type,
--                      price_change_reason,
--                      product_sale_price,
--                      confirm_by,
--                      sale_currency,
--                      dateend,
--                      price_change_confirm_yn,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by,
--                      standard_sale_price
--                     )
--              VALUES (NVL (:NEW.customer_code, '*'), --CUSTOMER_CODE,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      NULL, --CONFIRM_DATE,
--                      'T', --PRICE_TYPE,
--                      'N', --PRICE_CHANGE_REASON,
--                      NVL (:NEW.sale_price, 0),
--                      
----* (1 - (f_get_volume_dc_rate(:new.customer_code , :new.organization_id)/100) ), --PRODUCT_SALE_PRICE,
--                      '', --CONFIRM_BY,
--                      f_get_local_currency (:NEW.organization_id),
--                      --SALE_CURRENCY,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by,
--                      NVL (:NEW.sale_price, 0)
--                     );
--      
-----------------------------------------------------------------
--      ELSIF :NEW.item_division = 'C'
--      THEN
--         INSERT INTO is_product_work_cost
--                     (customer_code,
--                      item_code,
--                      product_line_type,
--                      dateset,
--                      organization_id,
--                      confirm_date,
--                      price_type,
--                      price_change_reason,
--                      product_work_cost,
--                      confirm_by,
--                      work_currency,
--                      dateend,
--                      price_change_confirm_yn,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by
--                     )
--              VALUES (NVL (:NEW.customer_code, '*'), --CUSTOMER_CODE,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      NULL, --CONFIRM_DATE,
--                      'T', --PRICE_TYPE,
--                      'N', --PRICE_CHANGE_REASON,
--                      0, --PRODUCT_SALE_PRICE,
--                      '', --CONFIRM_BY,
--                      f_get_local_currency (:NEW.organization_id),
--                      --SALE_CURRENCY,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by
--                     );
--      ELSIF :NEW.item_division = 'G' -- GOODS
--      THEN
--         INSERT INTO is_product_sale_price
--                     (customer_code,
--                      item_code,
--                      product_line_type,
--                      dateset,
--                      organization_id,
--                      confirm_date,
--                      price_type,
--                      price_change_reason,
--                      product_sale_price,
--                      confirm_by,
--                      sale_currency,
--                      dateend,
--                      price_change_confirm_yn,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by,
--                      standard_sale_price
--                     )
--              VALUES (NVL (:NEW.customer_code, '*'), --CUSTOMER_CODE,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      NULL, --CONFIRM_DATE,
--                      'T', --PRICE_TYPE,
--                      'N', --PRICE_CHANGE_REASON,
--                      NVL (:NEW.sale_price, 0),
--                      
----* (1 - (f_get_volume_dc_rate(:new.customer_code , :new.organization_id)/100) ), --PRODUCT_SALE_PRICE,
--                      '', --CONFIRM_BY,
--                      f_get_local_currency (:NEW.organization_id),
--                      --SALE_CURRENCY,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by,
--                      NVL (:NEW.sale_price, 0)
--                     );
--
--         INSERT INTO is_material_sale_price
--                     (customer_code,
--                      item_code,
--                      line_type,
--                      dateset,
--                      organization_id,
--                      confirm_date,
--                      price_type,
--                      price_change_reason,
--                      product_sale_price,
--                      sale_currency,
--                      confirm_by,
--                      dateend,
--                      price_change_confirm_yn,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by
--                     )
--              VALUES (NVL (:NEW.customer_code, '*'), --CUSTOMER_CODE,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      NULL, --CONFIRM_DATE,
--                      'T', --PRICE_TYPE,
--                      'N', --PRICE_CHANGE_REASON,
--                      NVL (:NEW.sale_price, 0), --PRODUCT_SALE_PRICE,
--                      f_get_local_currency (:NEW.organization_id),
--                      '', --CONFIRM_BY,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by
--                     );
--
--         
-----------------------------------------------------------------------------
--         INSERT INTO is_product_buy_price
--                     (supplier_code,
--                      item_code,
--                      line_type,
--                      dateset,
--                      organization_id,
--                      delivery,
--                      currency,
--                      unit_price,
--                      price_type,
--                      tax_rate,
--                      approval_no,
--                      standard_unit_price,
--                      dateend,
--                      confirm_date,
--                      price_change_reason,
--                      price_change_confirm_yn,
--                      confirm_by,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by
--                     )
--              VALUES (:NEW.supplier_code,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      '1', --DELIVERY,
--                      f_get_local_currency (:NEW.organization_id), --CURRENCY,
--                      NVL (:NEW.buy_price, 0), --PRICE,
--                      'T', --
--                      0, --TAX_RATE,
--                      '', --APPROVAL_NO,
--                      NVL (:NEW.buy_price, 0), --STANDARD_UNIT_PRICE,
--                      :NEW.dateend,
--                      NULL, --CONFIRM_DATE,
--                      'N', --PRICE_CHANGE_REASON,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      NULL, --CONFIRM_BY,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by
--                     );
--      
-----------------------------------------------------------------------------
--      END IF;
   END IF;
END;
