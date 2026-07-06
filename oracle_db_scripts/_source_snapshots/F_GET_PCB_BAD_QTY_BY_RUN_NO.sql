FUNCTION "F_GET_PCB_BAD_QTY_BY_RUN_NO" (p_run_no IN VARCHAR2, p_org IN NUMBER)
   RETURN NUMBER
IS
   lvl_return   NUMBER;
BEGIN
   SELECT nvl(SUM (BAD_QTY) , 0)
     INTO lvl_return
     FROM IP_PRODUCT_WORK_QC
    WHERE run_no = p_run_no
    AND organization_id = p_org;

   RETURN lvl_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;