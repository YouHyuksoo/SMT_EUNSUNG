FUNCTION "F_GET_MAT_RECEIPT_BY_DATE" (
   p_item_code   IN   VARCHAR2,
   p_line_type   IN   VARCHAR2,
   p_date        IN   DATE,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_receipt_qty   NUMBER;
BEGIN
   SELECT SUM (receipt_qty)
     INTO lvf_receipt_qty
     FROM im_item_receipt
    WHERE item_code = p_item_code
      AND line_type = p_line_type
      AND receipt_date > p_date
      AND organization_id = p_org;

   RETURN NVL (lvf_receipt_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;