FUNCTION "F_GET_ITEM_SPEC" 
  ( p_item_code IN varchar2,
    p_dateset   IN date ,
    p_org IN number)
  RETURN  varchar2 IS

   lvs_item_spec                 varchar2(200);

BEGIN

    select item_spec
    into   lvs_item_spec
    from   id_item
    where  item_code = p_item_code
    and    dateset <= p_dateset
    and    dateend >= p_dateset
    and    organization_id = p_org ;

    RETURN lvs_item_spec ;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;