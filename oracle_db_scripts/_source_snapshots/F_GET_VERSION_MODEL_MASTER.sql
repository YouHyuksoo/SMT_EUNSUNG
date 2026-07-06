FUNCTION "F_GET_VERSION_MODEL_MASTER" (p_model_name IN VARCHAR2, p_org IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (10);
BEGIN
   SELECT VERSION
     INTO lvs_return
     FROM ip_product_model_master
    WHERE model_name = p_model_name AND organization_id = p_org;

   RETURN lvs_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '0';
   WHEN OTHERS
   THEN
      RETURN '';
END;