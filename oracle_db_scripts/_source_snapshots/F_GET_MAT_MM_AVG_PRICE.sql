FUNCTION "F_GET_MAT_MM_AVG_PRICE" (
   p_yyyymm      IN   VARCHAR2,
   p_item_code   IN   VARCHAR2,
   p_line_type   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_avg_price   NUMBER;
BEGIN
   SELECT AVG(mm_avg_price)
     INTO lvf_avg_price
     FROM im_item_inventory_close_mfs
    WHERE close_yyyymm = p_yyyymm
      AND item_code = p_item_code
      AND line_type = p_line_type
      AND organization_id = p_org
      AND location_code = 'M001'
      AND mm_avg_price > 0 ;
   RETURN lvf_avg_price;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;