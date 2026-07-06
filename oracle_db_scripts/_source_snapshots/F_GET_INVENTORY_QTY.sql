FUNCTION "F_GET_INVENTORY_QTY" (p_item_code IN VARCHAR2, p_org IN NUMBER)
   RETURN NUMBER
IS
   lvf_inventory_qty   NUMBER;
   lvf_item_division   VARCHAR2 (1);
BEGIN
   SELECT item_division
     INTO lvf_item_division
     FROM id_item
    WHERE item_code = p_item_code AND organization_id = p_org;

---------------------------------------------------------------
--
---------------------------------------------------------------

   IF lvf_item_division IN ( 'F' , 'G' )
   THEN
       lvf_inventory_qty:= 0;
   ELSIF lvf_item_division = 'W'
   THEN
     lvf_inventory_qty:= 0;
   ELSIF lvf_item_division = 'R'
   THEN
      SELECT SUM (NVL (inventory_qty, 0))
        INTO lvf_inventory_qty
        FROM im_item_inventory
       WHERE item_code = p_item_code AND organization_id = p_org;
   END IF;

   RETURN NVL (lvf_inventory_qty, 0);

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;