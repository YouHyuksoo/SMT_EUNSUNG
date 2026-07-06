FUNCTION "F_GET_MAT_LAST_UNIT_PRICE_CFM" (p_supplier_code IN VARCHAR2,
   p_item_code IN VARCHAR2, p_line_type IN VARCHAR2, p_date DATE,
   p_org IN NUMBER
)
   RETURN NUMBER
IS
   lvf_return                    NUMBER;
   lvd_date                      DATE;
BEGIN


  --RETURN 1 ;
  -----------------------------------------------------
  -- 단가 빼달라는 요청 20171207 곽차장
  -----------------------------------------------------
  
  
   BEGIN
   
   
      SELECT MAX(dateset)
      INTO   lvd_date
      FROM   im_item_unit_price
      WHERE  supplier_code = p_supplier_code AND item_code = p_item_code
             AND line_type = p_line_type AND dateset < p_date
             and price_change_confirm_yn = 'Y'
             AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

   SELECT unit_price
   INTO   lvf_return
   FROM   im_item_unit_price
   WHERE  supplier_code = p_supplier_code AND item_code = p_item_code
          AND line_type = p_line_type AND dateset = lvd_date
          and price_change_confirm_yn = 'Y'
          AND organization_id = p_org;
   RETURN lvf_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;