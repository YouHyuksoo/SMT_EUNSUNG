FUNCTION "F_GET_EXCHANGE_RATE_CONVERT" 
  ( p_basis_currency IN varchar2 , p_currency In varchar2 , p_type In varchar2 )
  RETURN  number IS

-- ---------   ------  -------------------------------------------
   lvf_exchange_rate                 number;

BEGIN

    RETURN 1 ;
    
    if p_type = 'F' then --first exchange rate


    select exchange_rate into lvf_exchange_rate
      from icom_exchange_rate
     where basis_currency = p_basis_currency
       and currency = p_currency
       and dateset  = to_date( to_char(sysdate , 'yyyymm')||'01','yyyymmdd') ;


    else


    select exchange_rate into lvf_exchange_rate
      from icom_exchange_rate
     where basis_currency = p_basis_currency
       and currency = p_currency
       and dateset  = trunc(sysdate) ;


    end if ;

    RETURN lvf_exchange_rate ;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        return 0 ;

   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;