TRIGGER "INFINITY21_JSMES"."ID_ITEM_UPD_MANUAL" 
 BEFORE
   UPDATE OF route_no
 ON id_item
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
   phase       VARCHAR2 (10);
BEGIN
   
 --  IF 1 = 2
--   THEN
   phase := '10';

   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_inventory
       WHERE item_code = :OLD.item_code
         AND line_type = :OLD.line_type
         AND organization_id = :OLD.organization_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_count := 0;
   END;

   phase := '20';

   IF lvi_count > 0
   THEN
      DELETE FROM im_item_inventory
            WHERE item_code = :OLD.item_code
              AND line_type <> :OLD.line_type
              AND organization_id = :OLD.organization_id;

      phase := '30';

      UPDATE im_item_receipt
         SET line_type = :OLD.line_type
       WHERE item_code = :OLD.item_code
         AND line_type <> :OLD.line_type
         AND organization_id = :OLD.organization_id;

      phase := '40';

      UPDATE im_item_issue
         SET line_type = :OLD.line_type
       WHERE item_code = :OLD.item_code
         AND line_type <> :OLD.line_type
         AND organization_id = :OLD.organization_id;
   ELSE
      lvi_count := 0;
      phase := '50';

      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_inventory
          WHERE item_code = :OLD.item_code
            AND line_type <> :OLD.line_type
            AND organization_id = :OLD.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_count := 0;
      END;

      phase := '60';

      IF lvi_count = 0
      THEN
         NULL;
      ELSIF lvi_count = 1
      THEN
         UPDATE im_item_inventory
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;

         phase := '70';

         UPDATE im_item_receipt
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;

         phase := '80';

         UPDATE im_item_issue
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;
      ELSIF lvi_count > 1
      THEN
         phase := '90';

         DELETE FROM im_item_inventory a
               WHERE a.item_code = :OLD.item_code
                 AND a.ROWID <> (SELECT MAX (ROWID)
                                   FROM im_item_inventory b
                                  WHERE b.item_code = :OLD.item_code
                                    AND a.item_code = b.item_code
                                    AND a.organization_id = b.organization_id);

         phase := '100';

         UPDATE im_item_inventory
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;

         phase := '110';

         UPDATE im_item_receipt
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;

         phase := '120';

         UPDATE im_item_issue
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;
      END IF;
   END IF;
  /*     IF :NEW.set_item_yn = 'Y'
       THEN
          INSERT INTO is_product_sale_price
                      (customer_code,
                       item_code,
                       product_line_type,
                       dateset,
                       organization_id,
                       confirm_date,
                       price_type,
                       price_change_reason,
                       product_sale_price,
                       confirm_by,
                       sale_currency,
                       dateend,
                       price_change_confirm_yn,
                       enter_by,
                       enter_date,
                       last_modify_date,
                       last_modify_by
                      )
               VALUES (NVL(:OLD.customer_code, '*'), --CUSTOMER_CODE,
                       :OLD.item_code,
                       :OLD.line_type,
                       :OLD.dateset,
                       :OLD.organization_id,
                       NULL, --CONFIRM_DATE,
                       'T', --PRICE_TYPE,
                       'N', --PRICE_CHANGE_REASON,
                       0, --PRODUCT_SALE_PRICE,
                       '', --CONFIRM_BY,
                       'CNY', --SALE_CURRENCY,
                       :OLD.dateend,
                       'N', --PRICE_CHANGE_CONFIRM_YN,
                       :OLD.enter_by,
                       :OLD.enter_date,
                       :OLD.last_modify_date,
                       :OLD.last_modify_by
                      );
       END IF;*/
--  END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003,    'phase='
                                       || phase
                                       || ' '
                                       || SQLERRM);
END;