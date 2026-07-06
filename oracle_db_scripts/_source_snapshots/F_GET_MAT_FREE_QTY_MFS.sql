FUNCTION "F_GET_MAT_FREE_QTY_MFS" (
   p_material_mfs   IN   VARCHAR,
   p_item_code      IN   VARCHAR2,
   p_line_type      IN   VARCHAR2,
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
          material_mfs = p_material_mfs AND
          organization_id = p_org;
   RETURN lvf_free_qty;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;