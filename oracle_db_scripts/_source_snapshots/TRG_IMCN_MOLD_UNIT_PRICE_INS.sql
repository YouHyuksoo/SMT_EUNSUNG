TRIGGER "INFINITY21_JSMES"."TRG_IMCN_MOLD_UNIT_PRICE_INS" 
 BEFORE
  INSERT
 ON imcn_mold_unit_price
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   UPDATE imcn_mold_unit_price
      SET dateend =   :NEW.dateset
                    - 1
    WHERE supplier_code = :NEW.supplier_code
      AND mold_code = :NEW.mold_code
      AND currency = :NEW.currency
      AND dateset <= :NEW.dateset
      AND dateend >= :NEW.dateset
      AND organization_id = :NEW.organization_id;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;