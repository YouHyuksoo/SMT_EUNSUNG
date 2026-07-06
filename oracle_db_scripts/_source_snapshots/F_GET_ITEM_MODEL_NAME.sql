FUNCTION "F_GET_ITEM_MODEL_NAME" 
  ( p_item_code IN varchar2,
    p_dateset   IN date ,
    p_org IN number)
  RETURN  varchar2 IS

   lvs_model_name                 varchar2(30);

BEGIN

    select model_name
    into   lvs_model_name
    from   id_item
    where  item_code = p_item_code
    and    dateset <= p_dateset
    and    dateend >= p_dateset
    and    organization_id = p_org ;

    RETURN lvs_model_name ;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;