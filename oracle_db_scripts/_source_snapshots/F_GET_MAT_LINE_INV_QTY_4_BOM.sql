FUNCTION "F_GET_MAT_LINE_INV_QTY_4_BOM" (
   p_item_code        IN   VARCHAR2,
   p_line_code  in varchar2 ,
   p_workstage_code   IN   VARCHAR2,
   p_org              IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_inventory_qty             NUMBER;
BEGIN
   SELECT SUM(inventory_qty)
   INTO   lvf_inventory_qty
   FROM   im_item_workstage_inventory
   WHERE      item_code = p_item_code
          AND line_code LIKE p_line_code
          AND workstage_code LIKE p_workstage_code
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