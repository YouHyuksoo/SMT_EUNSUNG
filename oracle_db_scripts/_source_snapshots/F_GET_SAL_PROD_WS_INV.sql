FUNCTION "F_GET_SAL_PROD_WS_INV" (
   p_mfs         IN   VARCHAR2,
   p_item_code   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_inventory_qty             NUMBER;
BEGIN
   SELECT SUM(NVL(inventory_qty, 0))
   INTO   lvf_inventory_qty
   FROM   im_item_workstage_inventory
   WHERE  item_code = p_item_code AND
          mfs = p_mfs             AND
          organization_id = p_org;
   RETURN NVL(lvf_inventory_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;