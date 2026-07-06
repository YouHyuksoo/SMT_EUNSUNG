FUNCTION "F_GET_MAT_WS_INV_QTY_BY_M_MFS" (
   p_material_mfs   IN   VARCHAR2,
   p_item_code      IN   VARCHAR2,
   p_line_type      IN   VARCHAR2,
   p_org            IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_inventory_qty             NUMBER;
BEGIN
   SELECT SUM(inventory_qty)
   INTO   lvf_inventory_qty
   FROM   im_item_workstage_inventory
   WHERE      material_mfs = p_material_mfs
          AND item_code = p_item_code
          AND line_type = p_line_type
          AND organization_id = p_org;
   RETURN NVL(lvf_inventory_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;