FUNCTION "F_GET_MAT_INVENTORY_QTY_ALL" (
   as_item_code   IN VARCHAR2,
   ai_org         IN NUMBER)
   RETURN NUMBER
IS
   al_inventory_qty   NUMBER;
BEGIN
   BEGIN


      SELECT SUM (NVL (inventory_qty, 0))
        INTO al_inventory_qty
        FROM im_item_inventory
       WHERE item_code = as_item_code AND organization_id = ai_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         al_inventory_qty := 0;
   END;



   RETURN NVL (al_inventory_qty, 0);
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