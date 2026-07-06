FUNCTION "F_GET_CUSTOMER_NAME_FULL" 
  ( p_customer_code IN varchar2 , p_org IN number )
  RETURN  varchar2 IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the function
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------
   lvs_customer_name                 varchar2(30);
   -- Declare program variables as shown above
BEGIN

    select customer_name into lvs_customer_name
      from icom_customer
     where customer_code = p_customer_code
       and organization_id = p_org ;


    RETURN lvs_customer_name ;
EXCEPTION
   WHEN no_data_found then
       return 'NOTFOUND';

   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;