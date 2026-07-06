FUNCTION "F_GET_MAT_LINE_R_INV_QTY_4_BOM" (
   p_parent_item_code   IN   VARCHAR2,
   p_item_code          IN   VARCHAR2,
   p_line_code          IN   VARCHAR2,
   p_workstage_code     IN   VARCHAR2,
   p_org                IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_inventory_qty             NUMBER;
BEGIN
   SELECT SUM(a.inventory_qty)
   INTO   lvf_inventory_qty
   FROM   im_item_workstage_inventory a
   WHERE      a.item_code IN (SELECT b.replace_item_code
                              FROM   id_item_replace b
                              WHERE      b.parent_item_code =
                                                           p_parent_item_code
                                     AND b.child_item_code = p_item_code
                                     AND b.organization_id = p_org)
          AND a.line_code = p_line_code
          AND a.workstage_code = p_workstage_code
          AND a.organization_id = p_org;
   RETURN NVL(lvf_inventory_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;