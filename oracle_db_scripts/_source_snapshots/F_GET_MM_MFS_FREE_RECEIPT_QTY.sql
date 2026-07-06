FUNCTION "F_GET_MM_MFS_FREE_RECEIPT_QTY" (
   as_supplier_code   IN   VARCHAR2,
   as_material_mfs    IN   VARCHAR2,
   as_item_code       IN   VARCHAR2,
   as_line_type       IN   VARCHAR2,
   as_yyyymm          IN   VARCHAR2,
   ai_org             IN   NUMBER
)
   RETURN NUMBER
IS
   al_receipt_qty                NUMBER;
BEGIN
   SELECT NVL(SUM(receipt_qty), 0)
   INTO   al_receipt_qty
   FROM   im_item_free_receipt
   WHERE      supplier_code = as_supplier_code
          AND item_code = as_item_code
          AND line_type = as_line_type
          AND material_mfs = as_material_mfs
          AND receipt_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id )

--    and    receipt_status <> 'C'
          AND organization_id = ai_org;
   RETURN al_receipt_qty;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error(-20003, SQLERRM);
   WHEN OTHERS
   THEN
      ROLLBACK;
      raise_application_error(-20003, SQLERRM);
END;