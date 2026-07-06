FUNCTION F_GET_RUN_MODEL_NAME (p_run_no IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2(100);
BEGIN
   SELECT MODEL_NAME
     INTO lvs_return
     FROM ip_product_run_card
    WHERE run_no = p_run_no;

   RETURN lvs_return;
   
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'NULL' ;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
