FUNCTION "F_GET_TIME_TERM" 
  ( param1 IN DATE ,param2 IN DATE )
  RETURN  number IS


lvl_time NUMBER ;

BEGIN


    lvl_time := ROUND((param2 - param1 ) * 60 * 24);


    RETURN lvl_time ;

EXCEPTION
   WHEN others THEN
       raise_application_error( -20003 , SQLERRM ) ;
END;