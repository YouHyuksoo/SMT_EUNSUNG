FUNCTION "F_GET_MM_WORKSTAGE_INV_QTY" (
   as_line_code        IN   VARCHAR2,
   as_workstage_code   IN   VARCHAR2,
   as_mfs              IN   VARCHAR2,
   as_material_mfs     IN   VARCHAR2,
   as_item_code        IN   VARCHAR2,
   as_line_type        IN   VARCHAR2,
   as_yyyymm           IN   VARCHAR2,
   ai_org              IN   NUMBER
)
   RETURN NUMBER
IS
   al_inventory_qty              NUMBER;
BEGIN
   SELECT SUM(NVL(mm_inventory_qty, 0))
   INTO   al_inventory_qty
   FROM   im_item_workstage_inv_close
   WHERE      item_code = as_item_code
          AND close_yyyymm = as_yyyymm
          AND line_code = as_line_code
          AND workstage_code = as_workstage_code
          AND mfs = as_mfs
          AND material_mfs = as_material_mfs
          AND line_type = as_line_type
          AND organization_id = ai_org;
   RETURN NVL(al_inventory_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error(-20003, SQLERRM);
   WHEN OTHERS
   THEN
      ROLLBACK;
      raise_application_error(-20003, SQLERRM);
END;