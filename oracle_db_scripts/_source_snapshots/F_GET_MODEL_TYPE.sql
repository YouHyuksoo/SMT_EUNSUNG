FUNCTION "F_GET_MODEL_TYPE" (p_model_name IN VARCHAR2, p_org IN NUMBER)
   RETURN varchar2
IS
   lvs_return   varchar2(10);
BEGIN
   SELECT model_type
     INTO lvs_return
     FROM ip_product_model_master
    WHERE item_code = p_model_name AND organization_id = p_org;

   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;