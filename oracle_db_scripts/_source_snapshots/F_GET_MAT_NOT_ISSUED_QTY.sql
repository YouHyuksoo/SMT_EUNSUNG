FUNCTION "F_GET_MAT_NOT_ISSUED_QTY" (
   p_item_code   IN   VARCHAR2,
   p_line_type   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_qty                       NUMBER;
BEGIN
   SELECT SUM(NVL(issue_plan_qty, 0) - NVL(issue_qty, 0))
   INTO   lvf_qty
   FROM   im_item_work_order
   WHERE  item_code = p_item_code AND
          line_type = p_line_type AND
          organization_id = p_org;
   RETURN lvf_qty;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      RETURN 0;
END;