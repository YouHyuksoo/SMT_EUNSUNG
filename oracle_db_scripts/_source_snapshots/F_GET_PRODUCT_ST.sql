FUNCTION "F_GET_PRODUCT_ST" (
   p_item_code        IN   VARCHAR2,
   p_line_code        IN   VARCHAR2,
   p_workstate_code   IN   VARCHAR2,
   p_machine_code     IN   VARCHAR2,
   p_org              IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_st             NUMBER;
   lvs_config_value   VARCHAR2 (1);
BEGIN
------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
   BEGIN
      SELECT NVL (config_value, 'Y')
        INTO lvs_config_value
        FROM isys_config
       WHERE config_name = 'PRODUCT_ST_BY_ITEM'
         AND use_yn = 'Y'
         AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_config_value := 'Y';
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   IF lvs_config_value = 'Y'
   THEN
---------------------------------------
-- BY ITEM
---------------------------------------
      SELECT MIN (NVL (st_value, 0))
        INTO lvf_st
        FROM ip_product_st
       WHERE item_code = p_item_code AND organization_id = p_org;
   ELSE
      IF p_line_code = '%'
      THEN
         SELECT MIN (NVL (st_value, 0))
           INTO lvf_st
           FROM ip_product_st
          WHERE item_code = p_item_code AND organization_id = p_org;
      ELSE
---------------------------------------
--
---------------------------------------
         SELECT NVL (st_value, 0)
           INTO lvf_st
           FROM ip_product_st
          WHERE item_code = p_item_code
            AND line_code = p_line_code
            AND workstage_code = p_workstate_code
            AND machine_code = p_machine_code
            AND organization_id = p_org;
      END IF;
   END IF;

   RETURN lvf_st;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;