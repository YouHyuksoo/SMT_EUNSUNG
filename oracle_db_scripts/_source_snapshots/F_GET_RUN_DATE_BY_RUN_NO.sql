FUNCTION "F_GET_RUN_DATE_BY_RUN_NO" (p_run_no IN VARCHAR2)
   RETURN DATE
IS
   lvdt_return   DATE;
BEGIN
   SELECT run_date
     INTO lvdt_return
     FROM ip_product_run_card
    WHERE run_no = p_run_no;

   RETURN lvdt_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;