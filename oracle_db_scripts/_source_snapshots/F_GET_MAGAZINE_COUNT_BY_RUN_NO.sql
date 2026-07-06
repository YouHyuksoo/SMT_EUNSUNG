FUNCTION "F_GET_MAGAZINE_COUNT_BY_RUN_NO" (
   p_line_code        IN     VARCHAR2,
   p_workstage_code   IN     VARCHAR2,
   p_run_no           IN     VARCHAR2,
   p_org              IN     NUMBER)
RETURN NUMBER
IS
    lvl_count   number;

BEGIN
    SELECT   count(1)
      INTO   lvl_count
      FROM   ip_product_2d_barcode
     WHERE   line_code = p_line_code
       --AND   workstage_code = p_workstage_code
       AND   work_order_no = p_run_no
       AND   organization_id = p_org
       AND   magazine_no is not null;

    RETURN lvl_count;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
    WHEN OTHERS
    THEN
        RETURN -1;
END;