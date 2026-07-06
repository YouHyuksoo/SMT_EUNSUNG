FUNCTION "F_GET_LOT_SIZE" (p_run_no       IN VARCHAR2,
/* Formatted on 2012-12-26 ?????? 7:15:45 (QP5 v5.126) */
                         p_model_name   IN VARCHAR2,
                         p_mfs          IN VARCHAR2,
                         p_org          IN NUMBER)
    RETURN NUMBER
IS
    lvl_return   NUMBER;
    lvl_total    NUMBER;
BEGIN
      SELECT   SUM (plan_qty)
               - ( SUM (NVL (actual_qty, 0)) )
        INTO   lvl_total
        FROM   ip_product_mi_plan
       WHERE   mfs = p_mfs AND organization_id = p_org
    GROUP BY   mfs;

    RETURN lvl_total;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        raise_application_error (-20003, lvl_total || '  ' || SQLERRM);
        RETURN 0;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, p_mfs || '  ' || SQLERRM);
END;