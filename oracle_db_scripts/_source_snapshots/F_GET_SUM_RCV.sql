FUNCTION "F_GET_SUM_RCV" (
   p_material_mfs   IN   VARCHAR2,
   p_item_code      IN   VARCHAR2,
   p_line_type      IN   VARCHAR2,
   p_org            IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_return         NUMBER;
   lvs_config_value   VARCHAR2 (1);
BEGIN

------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
   BEGIN
      SELECT NVL (config_value, 'N')
        INTO lvs_config_value
        FROM isys_config
       WHERE config_name = 'MATERIAL_MFS_REPLACE_LOCATION'
         AND use_yn = 'Y'
         AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_config_value := 'N';
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   IF    lvs_config_value = 'N'
      OR lvs_config_value IS NULL
   THEN
      lvs_config_value := 'N';
   END IF;

   SELECT SUM (receipt_qty)
     INTO lvf_return
     FROM im_item_receipt
    WHERE item_code = p_item_code
      AND line_type = p_line_type
      AND DECODE (lvs_config_value, 'Y', location_code, material_mfs) =
                                                                p_material_mfs
      AND
--          receipt_status = 'N'          AND
          organization_id = p_org;
   RETURN lvf_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;