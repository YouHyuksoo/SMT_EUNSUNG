TRIGGER "INFINITY21_JSMES"."TRG_IM_SALE_PRICE_INS" 
 BEFORE
  INSERT
 ON im_item_sale_price
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   UPDATE im_item_sale_price
      SET dateend =   :NEW.dateset
                    - 1
    WHERE supplier_code = :NEW.supplier_code
      AND item_code = :NEW.item_code
      AND sale_currency = :NEW.sale_currency
      AND line_type = :NEW.line_type
      AND dateset <= :NEW.dateset
      AND dateend >= :NEW.dateset
      AND organization_id = :NEW.organization_id;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;