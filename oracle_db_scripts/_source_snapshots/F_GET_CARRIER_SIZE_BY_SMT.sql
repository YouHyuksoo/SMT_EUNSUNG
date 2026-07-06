FUNCTION "F_GET_CARRIER_SIZE_BY_SMT" (
   p_smt_model_name   IN VARCHAR2,
   p_org          IN NUMBER)
   RETURN NUMBER
IS
   lvl_return   NUMBER;
BEGIN
   SELECT max(NVL (carrier_size, 1))
     INTO lvl_return
     FROM ip_product_model_master
    WHERE smt_MODEL_NAME = p_smt_model_name AND organization_id = p_org;

   RETURN lvl_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 1;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;