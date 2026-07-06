FUNCTION "F_GET_MM_MFS_FB_RECEIPT_AMT" (
   as_material_mfs   IN   VARCHAR2,
   as_item_code      IN   VARCHAR2,
   as_yyyymm         IN   VARCHAR2,
   as_line_type      IN   VARCHAR2,
   ai_org            IN   NUMBER
)
   RETURN NUMBER
IS
   al_receipt_amt                NUMBER;
BEGIN
   SELECT SUM(NVL(receipt_amt, 0))
   INTO   al_receipt_amt
   FROM   im_item_fback_receipt
   WHERE  item_code = as_item_code                                              AND
          line_type = as_line_type                                              AND
          material_mfs = as_material_mfs                                        AND
          receipt_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id )
                                                                                AND
--          receipt_status <> 'C'                                                 AND
          organization_id = ai_org;
   RETURN nvl(al_receipt_amt,0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error(-20003, SQLERRM);
   WHEN OTHERS
   THEN
      ROLLBACK;
      raise_application_error(-20003, SQLERRM);
END;