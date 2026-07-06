FUNCTION "F_GET_MM_LAST_MON_LOC_INV_QTY" (
   as_yyyymm          IN   VARCHAR2,
   as_item_code       IN   VARCHAR2,
   as_line_type       IN   VARCHAR2,
   as_location_code   IN   VARCHAR2,
   ai_org             IN   NUMBER
)
   RETURN NUMBER
IS
   al_inv_qty   NUMBER;
BEGIN
   SELECT SUM (NVL (mm_inventory_qty, 0))
     INTO al_inv_qty
     FROM im_item_inventory_close
    WHERE item_code = as_item_code
      AND line_type = as_line_type
      AND location_code = as_location_code
      AND close_yyyymm =
             TO_CHAR (ADD_MONTHS (TO_DATE (as_yyyymm || '01', 'yyyymmdd'), -1),
                      'yyyymm'
                     )
      AND organization_id = ai_org;

   RETURN NVL (al_inv_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      ROLLBACK;
      raise_application_error (-20003, SQLERRM);
END;