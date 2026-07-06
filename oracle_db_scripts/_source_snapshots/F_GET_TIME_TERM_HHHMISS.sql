FUNCTION "F_GET_TIME_TERM_HHHMISS"
  ( param1 IN DATE ,param2 IN DATE )
  RETURN  VARCHAR2 IS


lvl_time    NUMBER ;
lvl_time_m  NUMBER ;
lvl_str     VARCHAR2(10);

BEGIN



    lvl_time   := param2 - param1;
    lvl_time_m := ROUND((param2 - param1 ) * 24 * 60);

    IF ( lvl_time_m/60 < 999 AND lvl_time_m >= 0 ) THEN   
         lvl_str := trim(to_char(trunc(lvl_time_m/60),'000'))||':'||to_char( trunc(sysdate) + lvl_time, 'MI:SS');
    ELSE
         lvl_str := '###:##';
    END IF;

    RETURN lvl_str ;



EXCEPTION
   WHEN others THEN
       raise_application_error( -20003 , SQLERRM ) ;
END;
