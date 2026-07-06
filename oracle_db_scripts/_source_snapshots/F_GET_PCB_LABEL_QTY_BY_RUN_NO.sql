FUNCTION "F_GET_PCB_LABEL_QTY_BY_RUN_NO" (
   p_run_no   IN   VARCHAR2,
   p_org      IN   NUMBER
)
   RETURN NUMBER
IS
   lvl_return   NUMBER;
BEGIN
  
   SELECT COUNT (*)
     INTO lvl_return
     FROM ip_product_2D_barcode
    WHERE run_no          = p_run_no
      AND organization_id = p_org;

   RETURN lvl_return;
   
EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN 0;
   WHEN OTHERS THEN
        raise_application_error (-20003, SQLERRM);
END;
