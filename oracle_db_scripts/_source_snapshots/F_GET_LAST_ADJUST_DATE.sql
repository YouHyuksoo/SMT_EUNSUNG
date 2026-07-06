FUNCTION "F_GET_LAST_ADJUST_DATE" (p_jig_lot_no IN VARCHAR2)
   RETURN DATE
IS

lvdt_date date ;

BEGIN
  
   SELECT MAX (adjust_date)
     INTO lvdt_date
     FROM IMCN_JIG_FEEDER_ADJUST
    WHERE jig_lot_no = p_jig_lot_no;

  -- RETURN NVL( lvdt_date , SYSDATE - 100);
  RETURN lvdt_date ;
   
EXCEPTION
  
   WHEN NO_DATA_FOUND THEN
        RETURN NULL;
        
   WHEN OTHERS THEN
        RAISE_application_error (-20003, SQLERRM);
        
END f_get_last_adjust_date;
