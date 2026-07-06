FUNCTION "F_GET_LINE_CODE_BY_RUN_NO" (p_run_no IN VARCHAR2, p_org IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (10);
BEGIN
   SELECT line_code
     INTO lvs_return
     FROM ip_product_run_card
    WHERE run_no = p_run_no AND organization_id = p_org;

   RETURN lvs_return;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RETURN '*' ;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;