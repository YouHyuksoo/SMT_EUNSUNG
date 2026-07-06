FUNCTION "F_GET_LINE_STATUS_NAME" (p_line_code IN VARCHAR2)
/* Formatted on 2015-05-20 18:28:25 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (100);
BEGIN

    SELECT  NVL(code_mean_eng,'')
      INTO  lvs_return
      FROM  ip_product_line l,
            isys_basecode   c
     WHERE  l.line_status = c.code_name (+)
       AND  c.code_type = 'LINE STATUS'
       AND  l.line_code = p_line_code;


    RETURN lvs_return;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RETURN '';

END;
