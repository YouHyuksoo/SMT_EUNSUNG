FUNCTION "F_GET_MAT_UNIT_PRICE" (
   p_supplier_code   IN   VARCHAR2,
   p_item_code       IN   VARCHAR2,
   P_line_type       IN   VARCHAR2,
   p_date            IN   DATE,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_price   NUMBER;
BEGIN

 -- RETURN 1 ;
  -----------------------------------------------------
  -- 단가 빼달라는 요청 20171207 곽차장
  -----------------------------------------------------
  
   SELECT unit_price
     INTO lvf_price
     FROM im_item_unit_price
    WHERE supplier_code = p_supplier_code
      AND item_code = p_item_code
      AND line_type = p_line_type
      AND dateset <= p_date
      AND dateend >= p_date
      AND organization_id = p_org;

   RETURN lvf_price;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, p_item_code||'  '||SQLERRM);
END;