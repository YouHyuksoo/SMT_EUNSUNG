TRIGGER "INFINITY21_JSMES"."TRG_ICOM_CUSTOMER_COMPLAINTS" 
 BEFORE INSERT ON icom_customer_complaints
 FOR EACH ROW
DECLARE
BEGIN

    IF NVL(:new.serial_no, '') > '*' THEN

       IF :new.complaints_division = 'R' OR :new.complaints_division = 'W' THEN -- ？？？？？ ？？？？ ？？？？？？？？？？？？？？ ？？ ？？？？？reset

           UPDATE IP_PRODUCT_2D_BARCODE
              SET SHIPPING_DEFICIT = NULL,
                  LAST_MODIFY_DATE = SYSDATE,
                  LAST_MODIFY_BY   = 'COMPLAINTS TRG'
            WHERE ORGANIZATION_ID  = :NEW.ORGANIZATION_ID
              AND SERIAL_NO        = :NEW.SERIAL_NO;

       END IF;

    END IF;

EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;