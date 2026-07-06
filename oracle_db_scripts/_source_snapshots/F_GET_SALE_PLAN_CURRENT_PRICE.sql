FUNCTION "F_GET_SALE_PLAN_CURRENT_PRICE" (p_yyyy IN VARCHAR2, p_seq_no IN NUMBER,
   p_item_code IN VARCHAR2, p_line_type IN VARCHAR2, p_exchange_rate IN NUMBER,
   p_org IN NUMBER
)
   RETURN NUMBER
IS
   lvf_current_price             NUMBER;
BEGIN
   BEGIN
      SELECT DECODE(currency, 'CNY', unit_price, unit_price * p_exchange_rate)
      INTO   lvf_current_price
      FROM   im_item_current_unit_price_4_s
      WHERE  sale_plan_yyyy = p_yyyy AND seq_no = p_seq_no
             AND item_code = p_item_code AND line_type = p_line_type
             AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

   RETURN lvf_current_price;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;