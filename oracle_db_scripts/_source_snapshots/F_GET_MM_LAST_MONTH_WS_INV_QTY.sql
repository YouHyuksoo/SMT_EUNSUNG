FUNCTION "F_GET_MM_LAST_MONTH_WS_INV_QTY" (
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
   WHERE  close_yyyymm = as_yyyymm           AND
          item_code = as_item_code           AND
          line_type = as_line_type           AND
          organization_id = ai_org;
   RETURN NVL(al_inventory_qty,0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error(-20003, SQLERRM);
   WHEN OTHERS
   THEN
      ROLLBACK;
      raise_application_error(-20003, SQLERRM);
END;