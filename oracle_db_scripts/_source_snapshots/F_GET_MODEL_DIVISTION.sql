FUNCTION "F_GET_MODEL_DIVISTION" (p_model_name IN VARCHAR2, p_org IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (10);
BEGIN
   SELECT model_division
     INTO lvs_return
     FROM ip_product_model_master
    WHERE item_code = p_model_name AND organization_id = p_org;

   RETURN lvs_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '*';
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;