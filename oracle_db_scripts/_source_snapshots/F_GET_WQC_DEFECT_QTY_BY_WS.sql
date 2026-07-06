FUNCTION "F_GET_WQC_DEFECT_QTY_BY_WS" (p_run_no           IN VARCHAR2,
/* Formatted on 2013-01-30 11:10:19 (QP5 v5.126) */
                                      p_workstage_code   IN VARCHAR2)
    RETURN NUMBER
IS
    lvl_qty   NUMBER;
BEGIN
--SMT 9999 EXCEPTION
    SELECT   SUM (NVL (defect_qty, 0))
      INTO   lvl_qty
      FROM   iq_product_wqc
     WHERE       mfs = p_run_no
             AND workstage_code = p_workstage_code
             AND bad_reason_code <> '9999';

    RETURN NVL (lvl_qty, 0);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;