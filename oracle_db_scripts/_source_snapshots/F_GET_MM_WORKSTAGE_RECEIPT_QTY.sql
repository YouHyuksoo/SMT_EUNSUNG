FUNCTION "F_GET_MM_WORKSTAGE_RECEIPT_QTY" (
   as_line_code        IN   VARCHAR2,
   as_workstage_code   IN   VARCHAR2,
   as_mfs              IN   VARCHAR2,
   as_material_mfs     IN   VARCHAR2,
   as_item_code        IN   VARCHAR2,
   as_yyyymm           IN   VARCHAR2,
   ai_org              IN   NUMBER
)
   RETURN NUMBER
IS
   al_receipt_qty                NUMBER;
BEGIN
   SELECT NVL(SUM(receipt_qty), 0)
   INTO   al_receipt_qty
   FROM   im_item_workstage_receipt
   WHERE  item_code = as_item_code                                              AND
          receipt_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id ) AND
--          receipt_status <> 'C'                                                 AND
          line_code = as_line_code                                              AND
          workstage_code = as_workstage_code                                    AND
          mfs = as_mfs                                                          AND
          material_mfs = as_material_mfs                                        AND
          organization_id = ai_org;
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