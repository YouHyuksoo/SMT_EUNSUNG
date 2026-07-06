FUNCTION "F_GET_MAT_ORDER_BY_DATE_QTY" (
   p_supplier_code   IN   VARCHAR2,
   p_item_code       IN   VARCHAR2,
   p_line_type       IN   VARCHAR2,
   p_date            IN   DATE,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_order_qty   NUMBER;
BEGIN
   SELECT SUM (order_qty)
     INTO lvf_order_qty
     FROM im_item_purchase_order
    WHERE supplier_code = p_supplier_code
      AND item_code = p_item_code
      AND line_type = p_Line_type
      AND TRUNC(delivery_date) = TRUNC(p_date)
      AND organization_id = p_org;

   RETURN NVL (lvf_order_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;