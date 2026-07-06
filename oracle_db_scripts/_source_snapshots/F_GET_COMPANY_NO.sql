FUNCTION "F_GET_COMPANY_NO" (p_model_name IN VARCHAR2, p_org IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (10);
BEGIN
   SELECT company_no
     INTO lvs_return
     FROM IP_PRODUCT_MODEL_MASTER
    WHERE model_name = p_model_name
      AND organization_id = p_org;

   RETURN lvs_return;
EXCEPTION
   when no_data_found then
     return '*';
   WHEN OTHERS
   THEN
      raise_application_error (-20003, 'Model Name='||p_model_name||'  '||SQLERRM);
END;