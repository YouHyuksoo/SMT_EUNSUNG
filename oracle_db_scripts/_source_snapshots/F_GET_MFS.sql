FUNCTION "F_GET_MFS" 
  ( p_condition IN varchar2 , p_org IN number)
  RETURN  VARCHAR2 IS

   LVS_MFS VARCHAR2(30) ;

BEGIN

    if p_condition = 'C' then

       select to_char(sysdate , 'yy')||'C'||seq_mfs.NEXTVAL
         into lvs_mfs
         from dual ;

    end if ;

    RETURN LVS_MFS ;
EXCEPTION
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;