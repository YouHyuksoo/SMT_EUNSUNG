FUNCTION "F_GET_MAGAZINE_QTY_BY_RUN_NO" (
   p_run_no           IN     VARCHAR2,
   p_org              IN     NUMBER)
RETURN NUMBER
IS
    lvl_count   number;

BEGIN
    SELECT  sum(lot_qty) 
      INTO   lvl_count
      FROM   ip_product_run_card_io 
     WHERE run_no = p_run_no
       AND   organization_id = p_org;

    RETURN lvl_count;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
    WHEN OTHERS
    THEN
        RETURN -1;
END;