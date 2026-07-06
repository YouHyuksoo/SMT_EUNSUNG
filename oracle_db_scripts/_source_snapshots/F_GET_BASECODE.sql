FUNCTION "F_GET_BASECODE" 
  ( p_code_type IN varchar2,
    p_code_name IN varchar2,
    p_lang IN varchar2,
    p_org IN number)
  RETURN  varchar2 IS

   ls_return   VARCHAR2(100);

BEGIN

    SELECT  DECODE(p_lang, 'C', NVL(CODE_MEAN_LOCAL, ''), 'K', NVL(CODE_MEAN_KOR, ''), CODE_MEAN_ENG)
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