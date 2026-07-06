FUNCTION "F_GET_WQC_INSPECT_QTY" (p_run_no IN VARCHAR2)
    RETURN NUMBER
IS
    lvl_qty   NUMBER;
BEGIN
    SELECT   SUM (inspect_qty)
      INTO   lvl_qty
      FROM   iq_product_wqc
     WHERE   mfs = p_run_no;

    RETURN lvl_qty;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;