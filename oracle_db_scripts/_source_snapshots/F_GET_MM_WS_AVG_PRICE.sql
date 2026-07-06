FUNCTION "F_GET_MM_WS_AVG_PRICE" (
   as_yyyymm      IN   VARCHAR2,
   as_item_code   IN   VARCHAR2,
   as_line_type   IN   VARCHAR2,
   ai_org         IN   NUMBER
)
   RETURN NUMBER
IS
   al_avg_price                  NUMBER;
BEGIN
   SELECT AVG(NVL(mm_avg_price, 0))
     INTO al_avg_price
     FROM im_item_workstage_inv_close
    WHERE item_code = as_item_code AND
          close_yyyymm = as_yyyymm AND
          line_type = as_line_type AND
          mm_inventory_qty > 0     AND
          organization_id = ai_org;

   RETURN NVL(al_avg_price, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error(-20003, SQLERRM);
   WHEN OTHERS
   THEN
      ROLLBACK;
      raise_application_error(-20003, SQLERRM);
END;