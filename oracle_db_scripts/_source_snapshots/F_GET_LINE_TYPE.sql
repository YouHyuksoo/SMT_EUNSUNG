FUNCTION "F_GET_LINE_TYPE" (p_line_code IN VARCHAR2, p_org IN number)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (30);
BEGIN
   SELECT line_division
     INTO lvs_return
     FROM ip_product_line
    WHERE line_code = p_line_code
      AND ORGANIZATION_ID =  p_org ;

   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN '*' ;
END;