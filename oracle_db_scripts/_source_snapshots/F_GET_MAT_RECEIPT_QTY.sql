FUNCTION "F_GET_MAT_RECEIPT_QTY" (
   p_supplier_code   IN   VARCHAR2,
   p_item_code       IN   VARCHAR2,
   p_line_type       IN   VARCHAR2,
   p_dateset         IN   DATE,
   p_dateend         IN   DATE,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_receipt_qty               NUMBER;
BEGIN
   SELECT SUM(receipt_qty)
   INTO   lvf_receipt_qty
   FROM   im_item_receipt
   WHERE      supplier_code = p_supplier_code
          AND item_code = p_item_code
          AND line_type = p_line_type
          AND receipt_date >= p_dateset
          AND receipt_date <= p_dateend
          AND organization_id = p_org;
   RETURN nvl(lvf_receipt_qty,0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;