FUNCTION F_GET_MAT_WORK_COST_AMT (
   p_item_code   IN   VARCHAR2,
   p_line_type   IN   VARCHAR2,
   p_date        IN   DATE,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_work_cost   NUMBER;
BEGIN
--   SELECT work_cost_amt
--     INTO lvf_work_cost
--     FROM is_product_material_cost
--    WHERE item_code = p_item_code
--      AND product_line_type = p_line_type
--      AND dateset <= p_date
--      AND dateend >= p_date
--      AND organization_id = p_org;
--   RETURN NVL (lvf_work_cost, 0);
RETURN 0 ;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;

