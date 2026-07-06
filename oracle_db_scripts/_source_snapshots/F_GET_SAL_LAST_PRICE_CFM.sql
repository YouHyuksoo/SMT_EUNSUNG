FUNCTION "F_GET_SAL_LAST_PRICE_CFM" (
   p_customer_code       IN   VARCHAR2,
   p_item_code           IN   VARCHAR2,
   p_product_line_type   IN   VARCHAR2,
   p_date                     DATE,
   p_org                 IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_return                    NUMBER;
   lvd_date                      DATE;
BEGIN
   BEGIN
      SELECT MAX(dateset)
      INTO   lvd_date
      FROM   is_product_sale_price
      WHERE  customer_code = p_customer_code         AND
             item_code = p_item_code                 AND
             product_line_type = p_product_line_type AND
             dateset < p_date                        AND
             price_change_confirm_yn = 'Y'           AND
             organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

   SELECT product_sale_price
   INTO   lvf_return
   FROM   is_product_sale_price
   WHERE  customer_code = p_customer_code         AND
          item_code = p_item_code                 AND
          product_line_type = p_product_line_type AND
          dateset = lvd_date                      AND
          price_change_confirm_yn = 'Y'           AND
          organization_id = p_org;
   RETURN lvf_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;