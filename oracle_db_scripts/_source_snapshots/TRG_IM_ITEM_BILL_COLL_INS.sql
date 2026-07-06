TRIGGER "INFINITY21_JSMES"."TRG_IM_ITEM_BILL_COLL_INS" 
 BEFORE
  INSERT
 ON im_item_bill_collection
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvf_bill_collection_amt   NUMBER;
   lvf_sale_amt              NUMBER;
BEGIN
   BEGIN
      SELECT sale_amt, NVL (bill_collection_amt, 0)
        INTO lvf_sale_amt, lvf_bill_collection_amt
        FROM im_item_sale_invoice_master
       WHERE supplier_code = :NEW.supplier_code
         AND invoice_no = :NEW.invoice_no
         AND organization_id = :NEW.organization_id
         AND invoice_open_yn = 'Y';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'SALE INVOICE NOT FOUND '
            || :NEW.invoice_no
         );
   END;

   IF :NEW.bill_collection_amt < 0
   THEN
      IF lvf_sale_amt =
                    NVL (lvf_bill_collection_amt, 0)
                  + :NEW.bill_collection_amt
      THEN
         UPDATE im_item_sale_invoice_master
            SET bill_collection_amt =
                        NVL (bill_collection_amt, 0)
                      + :NEW.bill_collection_amt,
                bill_collection_type = 'C'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      ELSE
         UPDATE im_item_sale_invoice_master
            SET bill_collection_amt =
                        NVL (bill_collection_amt, 0)
                      + :NEW.bill_collection_amt,
                bill_collection_type = 'P'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      END IF;
   ELSE
      IF lvf_sale_amt =
                    NVL (lvf_bill_collection_amt, 0)
                  + :NEW.bill_collection_amt
      THEN
         UPDATE im_item_sale_invoice_master
            SET bill_collection_amt =
                        NVL (bill_collection_amt, 0)
                      + :NEW.bill_collection_amt,
                bill_collection_type = 'C'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      ELSE
         UPDATE im_item_sale_invoice_master
            SET bill_collection_amt =
                        NVL (bill_collection_amt, 0)
                      + :NEW.bill_collection_amt,
                bill_collection_type = 'P'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;