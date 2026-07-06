FUNCTION "F_GET_MAT_FREE_INVENTORY_PRICE" (
   p_item_code       IN   VARCHAR2,
   p_line_type       IN   VARCHAR2,
   p_supplier_code   IN   VARCHAR2,
   p_material_mfs    IN   VARCHAR2,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_price   NUMBER;
BEGIN
   SELECT inventory_price
     INTO lvf_price
     FROM im_item_free_inventory
    WHERE item_code = p_item_code
      AND supplier_code = p_supplier_code
      AND material_mfs = p_material_mfs
      AND line_type = p_line_type
      AND organization_id = p_org;

--if lvf_price = 0 then
--      raise_application_error (-20003, 'Inventory Price not found ITEM CODE='||p_item_code||' LINE TYPE='||p_line_type||SQLERRM);
--else
   RETURN lvf_price;
--   end if ;
EXCEPTION
   WHEN NO_DATA_FOUND

   THEN
--      raise_application_error (-20003, 'Inventory Price not found ITEM CODE='||p_item_code||' LINE TYPE='||p_line_type||SQLERRM);
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;