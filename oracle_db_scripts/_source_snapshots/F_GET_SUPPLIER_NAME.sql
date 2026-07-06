FUNCTION "F_GET_SUPPLIER_NAME" 
  ( p_supplier_code IN varchar2 , p_org IN number )
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
   lvs_supplier_name                 varchar2(50);
   -- Declare program variables as shown above
BEGIN

    select supplier_name into lvs_supplier_name
      from icom_supplier
     where supplier_code = p_supplier_code
       and organization_id = p_org ;


    RETURN lvs_supplier_name ;
EXCEPTION
   WHEN no_data_found then
       return 'NOTFOUND';

   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;