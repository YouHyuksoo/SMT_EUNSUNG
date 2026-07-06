FUNCTION "F_GET_CCS_OK_COUNT" (p_line_code IN VARCHAR2)
/* Formatted on 2015-04-25 ???? 10:49:34 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvl_return   NUMBER;
BEGIN
    SELECT   SUM (DECODE (ccs_yn, 'Y', 1, 0)) / COUNT ( * )
      INTO   lvl_return
      FROM   ib_product_plandata
     WHERE   line_code = p_line_code
       AND ACTIVE_YN = 'Y' ;

    RETURN lvl_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;