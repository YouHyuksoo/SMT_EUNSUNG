TRIGGER "INFINITY21_JSMES"."TRG_IM_ITEM_SALE_INVOICE_UPD" 
 AFTER
  UPDATE
 ON im_item_sale_invoice_master
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   IF :NEW.invoice_open_yn = 'Y'
   THEN
      UPDATE im_item_sale_receipt
         SET invoice_open_yn = 'Y'
       WHERE invoice_open_sequence = :OLD.invoice_open_sequence
         AND organization_id = :OLD.organization_id
         AND invoice_open_yn = 'R';
   ELSIF :NEW.invoice_open_yn = 'R'
   THEN
      UPDATE im_item_sale_receipt
         SET invoice_open_yn = 'R'
       WHERE invoice_open_sequence = :OLD.invoice_open_sequence
         AND organization_id = :OLD.organization_id
         AND invoice_open_yn = 'Y';
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;