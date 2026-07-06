FUNCTION "F_GET_ASSY_MFS" 
  ( p_org IN number)
  RETURN  VARCHAR2 IS

   LVS_MFS VARCHAR2(30) ;

BEGIN

       select to_char(sysdate , 'yy')||'A'||seq_mfs.NEXTVAL
         into lvs_mfs
         from dual ;

    RETURN LVS_MFS ;
EXCEPTION
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;