FUNCTION "F_GET_EXCHANGE_RATE" 
  ( p_date IN Date , p_currency IN varchar2 )
  RETURN  number IS

   lvf_exchange_rate                 number;

BEGIN
   
      RETURN 1 ;
  -----------------------------------------------------
  -- 단가 빼달라는 요청 20171207 곽차장
  -----------------------------------------------------

    select EXCHANGE_RATE into lvf_exchange_rate
      from icom_exchange_rate
     where dateset  = trunc(p_date)
       and currency = f_get_local_currency(1)
       and basis_currency = p_currency ;

    RETURN lvf_exchange_rate ;
EXCEPTION
   WHEN no_data_found THEN
       raise_application_error( -20003 ,to_char(p_date, 'yyyy/mm/dd hh24:mi:ss')||' LOCAL CURRENCY='||f_get_local_currency(1)||' '||p_currency||' Exchange Rate Not Found '|| sqlerrm ) ;
       return -1 ;

   WHEN others THEN

       raise_application_error( -20003 , sqlerrm ) ;
END;