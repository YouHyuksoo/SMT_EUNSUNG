FUNCTION F_GET_RUN_LOT_QTY (p_run_no IN VARCHAR2)
   RETURN NUMBER
IS
   lvdt_return   NUMBER;
BEGIN
   SELECT LOT_SIZE
     INTO lvdt_return
     FROM ip_product_run_card
    WHERE run_no = p_run_no;

   RETURN lvdt_return;
   
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0 ;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
