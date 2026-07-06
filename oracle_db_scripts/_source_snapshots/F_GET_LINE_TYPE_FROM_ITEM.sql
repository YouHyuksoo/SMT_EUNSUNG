FUNCTION "F_GET_LINE_TYPE_FROM_ITEM" 
  ( p_item_code IN varchar2, p_org IN number )
  RETURN  varchar2 IS

-- ---------   ------  -------------------------------------------
   lvs_line_type                 varchar2(10);

BEGIN

    SELECT line_type
      INTO lvs_line_type
      FROM id_item
     WHERE item_code = p_item_code
 --      AND dateset  <= TRUNC(SYSDATE)
 --      AND NVL(dateend,SYSDATE-1)  >= TRUNC(SYSDATE)
       AND organization_id = p_org ;

    RETURN lvs_line_type ;

EXCEPTION
   WHEN no_data_found THEN

   RETURN  '*' ;

  --     raise_application_error( -20003 , 'Item Code='||p_item_code||' '||sqlerrm ) ;

END;