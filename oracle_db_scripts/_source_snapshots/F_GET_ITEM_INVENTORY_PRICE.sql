FUNCTION "F_GET_ITEM_INVENTORY_PRICE" 
  ( p_item_code IN varchar2,
    p_line_type   IN varchar2 ,
    p_org IN number)
  RETURN  number IS

   lvs_item_price                 number;

BEGIN

       select  avg(inventory_price)
        into    lvs_item_price
        from   im_item_inventory
        where item_code     =     p_item_code
        and    line_type        = p_line_type
        and    organization_id  = p_org ;

    RETURN lvs_item_price ;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN 0;
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;




-- End of DDL Script for Function INFINITY21_JSMES.F_GET_ITEM_UOM