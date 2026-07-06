FUNCTION "F_GET_MAT_INVENTORY_PRICE" (
   p_item_code       IN   VARCHAR2,
   P_line_type       IN   VARCHAR2,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_price   NUMBER;
BEGIN
   SELECT AVG(inventory_price)
     INTO lvf_price
     FROM im_item_inventory
    WHERE item_code = p_item_code
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