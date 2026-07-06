FUNCTION "F_GET_MAT_FREE_INV_QTY_ITEM" (
   p_item_code      IN   VARCHAR2,
   p_org            IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_free_qty                  NUMBER;
BEGIN
   SELECT SUM(inventory_qty)
   INTO   lvf_free_qty
   FROM   im_item_free_inventory
   WHERE  item_code = p_item_code       AND
          organization_id = p_org;
   RETURN nvl(lvf_free_qty,0);
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;