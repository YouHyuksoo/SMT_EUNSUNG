TRIGGER "INFINITY21_JSMES"."TRG_IP_PROD_RESULT_BARCODE_DEL" 
 BEFORE
  DELETE
 ON ip_product_result_barcode
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvi_exists   NUMBER;
BEGIN
    BEGIN
        SELECT   COUNT ( * )
          INTO   lvi_exists
          FROM   ip_product_result
         WHERE       product_date = :old.product_date
                 AND product_sequence = :old.product_sequence
                 AND organization_id = :old.organization_id;
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
        UPDATE   ip_product_result
           SET   product_actual_qty =
                     product_actual_qty - :old.product_actual_qty
         WHERE       product_date = :old.product_date
                 AND product_sequence = :old.product_sequence
                 AND organization_id = :old.organization_id;

        DELETE FROM   ip_product_result
              WHERE       product_date = :old.product_date
                      AND product_sequence = :old.product_sequence
                      AND product_actual_qty = 0
                      AND organization_id = :old.organization_id;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;