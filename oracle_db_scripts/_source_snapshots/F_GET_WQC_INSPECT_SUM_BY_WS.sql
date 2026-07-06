FUNCTION "F_GET_WQC_INSPECT_SUM_BY_WS" (
    p_run_no           IN VARCHAR2,
    p_workstage_code   IN VARCHAR2)
    RETURN NUMBER
IS
    lvl_qty   NUMBER;
BEGIN
    IF p_workstage_code = 'S060' --router
    THEN
        SELECT   SUM (inspect_bad_qty)
          INTO   lvl_qty
          FROM   iq_product_wqc
         WHERE       mfs = p_run_no
                 AND workstage_code <= p_workstage_code
                 AND workstage_code >  'S010' --SMT
                 AND bad_reason_code <> '9999'
                 AND workstage_code IN
                            (SELECT   workstage_code
                               FROM   ip_product_workstage
                              WHERE   (NVL (bad_qty_extract_yn, 'N') = 'N'
                                       OR workstage_code = 'S060'));
    ELSE
        SELECT   SUM (inspect_bad_qty)
          INTO   lvl_qty
          FROM   iq_product_wqc
         WHERE   mfs = p_run_no AND workstage_code = p_workstage_code;
    END IF;

    RETURN lvl_qty;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;