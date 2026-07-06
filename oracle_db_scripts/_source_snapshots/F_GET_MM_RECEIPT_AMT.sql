FUNCTION "F_GET_MM_RECEIPT_AMT" (as_item_code   IN VARCHAR2,
/* Formatted on 5-1-2015 15:47:01 (QP5 v5.126) */
                               as_yyyymm      IN VARCHAR2,
                               as_line_type   IN VARCHAR2,
                               adt_dateset    IN DATE,
                               adt_dateend    IN DATE,
                               ai_org         IN NUMBER)
    RETURN NUMBER
IS
    al_receipt_amt   NUMBER;
    lvdt_start       DATE;
    lvdt_end         DATE;
BEGIN
    SELECT   SUM (NVL (receipt_amt, 0))
      INTO   al_receipt_amt
      FROM   im_item_receipt
     WHERE       item_code = as_item_code
             AND line_type = as_line_type
             AND ENTER_DATE >= adt_dateset
             AND ENTER_DATE <= adt_dateend
             AND organization_id = ai_org;

    RETURN al_receipt_amt;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        raise_application_error (-20003, SQLERRM);
    WHEN OTHERS
    THEN
        ROLLBACK;
        raise_application_error (-20003, SQLERRM);
END;