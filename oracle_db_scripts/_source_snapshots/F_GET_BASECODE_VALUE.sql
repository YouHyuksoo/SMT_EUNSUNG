FUNCTION "F_GET_BASECODE_VALUE" 
  ( p_code_type IN varchar2,
    p_code_name IN varchar2,
    p_org IN NUMBER)
  RETURN  varchar2 IS

   ls_return   VARCHAR2(100);

BEGIN

    SELECT  CODE_VALUE
    INTO    ls_return
    FROM    ISYS_BASECODE
    WHERE   CODE_TYPE       =   UPPER(p_code_type)
    AND     CODE_NAME       =   UPPER(p_code_name)
    AND     ORGANIZATION_ID =   p_org
    ;

    return ls_return;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;