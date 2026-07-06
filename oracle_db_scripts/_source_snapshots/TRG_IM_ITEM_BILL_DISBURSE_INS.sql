TRIGGER "INFINITY21_JSMES"."TRG_IM_ITEM_BILL_DISBURSE_INS" 
 AFTER
  INSERT
 ON im_item_bill_disburse
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvf_bill_disburse_amt   NUMBER;
   lvf_receipt_amt         NUMBER;
BEGIN
   BEGIN
      SELECT receipt_amt, NVL (bill_disburse_amt, 0)
        INTO lvf_receipt_amt, lvf_bill_disburse_amt
        FROM im_item_receipt_invoice_master
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

   IF :NEW.bill_disburse_amt < 0
   THEN
      IF lvf_receipt_amt =
                        NVL (lvf_bill_disburse_amt, 0)
                      + :NEW.bill_disburse_amt
      THEN
         UPDATE im_item_receipt_invoice_master
            SET bill_disburse_amt =
                            NVL (bill_disburse_amt, 0)
                          + :NEW.bill_disburse_amt,
                bill_disburse_type = 'C'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      ELSE
         UPDATE im_item_receipt_invoice_master
            SET bill_disburse_amt =
                            NVL (bill_disburse_amt, 0)
                          + :NEW.bill_disburse_amt,
                bill_disburse_type = 'P'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      END IF;
   ELSE
      IF lvf_receipt_amt =
                        NVL (lvf_bill_disburse_amt, 0)
                      + :NEW.bill_disburse_amt
      THEN
         UPDATE im_item_receipt_invoice_master
            SET bill_disburse_amt =
                            NVL (bill_disburse_amt, 0)
                          + :NEW.bill_disburse_amt,
                bill_disburse_type = 'C'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      ELSE
         UPDATE im_item_receipt_invoice_master
            SET bill_disburse_amt =
                            NVL (bill_disburse_amt, 0)
                          + :NEW.bill_disburse_amt,
                bill_disburse_type = 'P'
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