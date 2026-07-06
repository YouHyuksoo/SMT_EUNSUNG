FUNCTION "F_GET_MAT_INVENTORY_QTY_ITEM" (
   as_item_code       IN   VARCHAR2,
   ai_org             IN   NUMBER
)
   RETURN NUMBER
IS
   al_inventory_qty   NUMBER;
   al_cnt             NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO al_cnt
        FROM im_item_inventory
       WHERE item_code = as_item_code
            AND location_code ='M01'
         AND organization_id = ai_org
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         al_cnt := 0;
   END;

   IF al_cnt < 1
   THEN
      RETURN 0;
--         raise_application_error( -20007, as_item_code||' This item is not in IM_INVENTORY By Normal Issue' );
   END IF;

   SELECT SUM (NVL (inventory_qty, 0))
     INTO al_inventory_qty
     FROM im_item_inventory
    WHERE item_code = as_item_code
      AND location_code ='M01'
      AND organization_id = ai_org;

   RETURN al_inventory_qty;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error (-20003, SQLERRM);
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
      RETURN 0;
END;