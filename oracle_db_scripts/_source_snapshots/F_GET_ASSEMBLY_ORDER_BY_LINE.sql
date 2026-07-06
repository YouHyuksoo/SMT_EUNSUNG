FUNCTION "F_GET_ASSEMBLY_ORDER_BY_LINE" (
   p_line_code   IN VARCHAR2,
   p_date        IN DATE)
   RETURN NUMBER
IS
   lvl_return   NUMBER;
BEGIN
   BEGIN
      SELECT NVL (SUM (plan_qty), 0)
        INTO lvl_return
        FROM IP_PRODUCT_SMD_PLAN
       WHERE  line_code = p_line_code
         AND  plan_date = trunc(sysdate) ;



   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_return := 0;
   END;


   RETURN NVL (lvl_return, 0);
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN 0;
END;