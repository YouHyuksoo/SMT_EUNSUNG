TRIGGER "INFINITY21_JSMES"."TRG_IP_ASSY_RESULT_BARCODE_DEL" 
 BEFORE
  DELETE
 ON ip_assembly_result_barcode
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_exists   NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvi_exists
        FROM ip_assembly_result
       WHERE product_date = :OLD.product_date
         AND product_sequence = :OLD.product_sequence
         AND organization_id = :OLD.organization_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_exists := 0;
   END;

   IF lvi_exists = 0
   THEN
      NULL;
   --   raise_application_error (-20003, 'PRODUCT RESULT NOT FOUND '||SQLERRM);
   ELSE
      UPDATE ip_assembly_result
         SET product_actual_qty =
                                  product_actual_qty
                                - :OLD.product_actual_qty
       WHERE product_date = :OLD.product_date
         AND product_sequence = :OLD.product_sequence
         AND organization_id = :OLD.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;