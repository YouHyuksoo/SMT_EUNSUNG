FUNCTION "F_GET_MAT_MAX_UNIT_PRICE_CFM" (
   p_item_code       IN   VARCHAR2,
   P_line_type       IN   VARCHAR2,
   p_date            IN   DATE,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_price   NUMBER;
   lvs_currency varchar2(3);
   phase varchar2(10) ;
BEGIN
 
  -- RETURN 1 ;
  -----------------------------------------------------
  -- 단가 빼달라는 요청 20171207 곽차장
  -----------------------------------------------------
 
   phase := '10' ;  
   SELECT max(unit_price) , max(currency)
     INTO lvf_price , lvs_currency
     FROM im_item_unit_price
    WHERE item_code = p_item_code
     -- AND line_type = p_line_type
      AND dateset <= p_date
      AND dateend >= p_date
     -- AND PRICE_CHANGE_CONFIRM_YN = 'Y'
      AND organization_id = p_org;

     phase := '20' ;   
    if f_get_local_currency(p_org) <> lvs_currency then
       phase := '30' ; 
       lvf_price := lvf_price * f_get_exchange_rate(p_date , lvs_currency);
       phase := '40' ; 
    end if ;

   RETURN NVL(lvf_price,0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, phase||' '||SQLERRM);
END;