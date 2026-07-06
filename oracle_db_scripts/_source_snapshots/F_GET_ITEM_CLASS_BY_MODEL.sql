FUNCTION "F_GET_ITEM_CLASS_BY_MODEL" (p_model_name IN VARCHAR2, p_org IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_item_class   VARCHAR2 (10);
BEGIN
   SELECT model_type
     INTO lvs_item_class
     FROM IP_PRODUCT_MODEL_MASTER
    WHERE item_code = p_model_name
      AND organization_id = p_org;

   RETURN lvs_item_class;
EXCEPTION
   when no_data_found then
     return '*';
   WHEN OTHERS
   THEN
      raise_application_error (-20003, 'Model Name='||p_model_name||'  '||SQLERRM);
END;