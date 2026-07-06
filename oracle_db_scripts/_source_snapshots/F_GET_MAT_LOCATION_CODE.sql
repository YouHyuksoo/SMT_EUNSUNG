FUNCTION "F_GET_MAT_LOCATION_CODE" (
   p_mfs         IN   VARCHAR2,
   p_item_code        VARCHAR2,
   p_line_type   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_location_code   VARCHAR2 (20);
BEGIN
   SELECT nvl(location_code,'*')
     INTO lvs_location_code
     FROM im_item_inventory
    WHERE material_mfs = p_mfs
      AND item_code = p_item_code
      AND line_type = p_line_type
      AND organization_id = p_org;
   RETURN lvs_location_code;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;