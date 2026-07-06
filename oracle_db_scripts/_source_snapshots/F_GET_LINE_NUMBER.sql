FUNCTION "F_GET_LINE_NUMBER" (p_line_code IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (10);
BEGIN
   SELECT line_name_num
     INTO lvs_return
     FROM ip_product_line
    WHERE line_code = p_line_code  ;

   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN '*';
END;