FUNCTION "F_CHECK_RUNCARD" (
   p_line   IN   VARCHAR2,
   p_runcard               IN   VARCHAR2
)
   RETURN VARCHAR2
IS
   lvi_count                     NUMBER;
BEGIN
   SELECT COUNT(*)
     INTO lvi_count
     FROM IP_PRODUCT_RUN_CARD
    WHERE line_code = p_line AND
          run_no = p_runcard;

   IF lvi_count = 0
   THEN
      RETURN '-1';
   ELSE
      RETURN '0';
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '-1';
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;