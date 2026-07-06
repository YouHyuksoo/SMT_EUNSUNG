FUNCTION "F_GET_MM_RECEIPT_QTY" (as_item_code   IN VARCHAR2,
/* Formatted on 5-1-2015 15:45:06 (QP5 v5.126) */
                               as_yyyymm      IN VARCHAR2,
                               as_line_type   IN VARCHAR2,
                               adt_dateset    IN DATE,
                               adt_dateend    IN DATE,
                               ai_org         IN NUMBER)
    RETURN NUMBER
IS
    al_receipt_qty   NUMBER;
      lvdt_start     DATE;
    lvdt_end       DATE;
BEGIN


    SELECT   f_get_inventory_close_date (as_yyyymm, 'START', ai_org),
             f_get_inventory_close_date (as_yyyymm, 'END', ai_org)
      INTO   lvdt_start, lvdt_end
      FROM   DUAL;


    SELECT   SUM (NVL (receipt_qty, 0))
      INTO   al_receipt_qty
      FROM   im_item_receipt
     WHERE       item_code = as_item_code
          --   AND line_type = as_line_type
             AND ENTER_DATE BETWEEN lvdt_start AND lvdt_end
             AND organization_id = ai_org;

    RETURN NVL (al_receipt_qty, 0);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        raise_application_error (-20003, SQLERRM);
    WHEN OTHERS
    THEN
        ROLLBACK;
        raise_application_error (-20003, SQLERRM);
END;