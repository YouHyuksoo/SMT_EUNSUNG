FUNCTION "F_GET_MAT_ISSUE_PRICE" (
   p_material_mfs    IN   VARCHAR2,
   p_item_code       IN   VARCHAR2,
   P_line_type       IN   VARCHAR2,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_price   NUMBER;
BEGIN
   SELECT inventory_price
     INTO lvf_price
     FROM im_item_inventory
    WHERE material_mfs = p_material_mfs
      AND item_code = p_item_code
      AND line_type = p_line_type
      AND organization_id = p_org;

   RETURN lvf_price;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;