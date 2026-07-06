FUNCTION "F_GET_MAT_LOCATION_ADDRESS" (
   p_item_code        VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_location_address  VARCHAR2 (20);
BEGIN
   SELECT nvl(location_address,'*')
     INTO lvs_location_address
     FROM id_item
    WHERE item_code = p_item_code
        AND organization_id = p_org;
   RETURN lvs_location_address;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;