FUNCTION "F_GET_LINE_STATUS" (p_line_code IN VARCHAR2)
/* Formatted on 2015-05-20 18:28:25 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (10);
BEGIN
    SELECT   line_status
      INTO   lvs_return
      FROM   ip_product_line
     WHERE   line_code = p_line_code;

    RETURN lvs_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 'N';
END;