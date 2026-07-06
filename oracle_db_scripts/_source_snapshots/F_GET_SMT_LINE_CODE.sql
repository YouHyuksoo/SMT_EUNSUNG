FUNCTION "F_GET_SMT_LINE_CODE" (p_run_no IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_line_code   VARCHAR2 (10);
BEGIN


   select decode(line_code, '01','A','02','B','03','C','04','D','05','E','06','S','07','G','08','H', '09', 'I', '10', 'J', '11', 'K', '*')
     into lvs_line_code
     from ip_product_run_card
    where run_no = p_run_no;
  
  
   RETURN lvs_line_code;
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RETURN '*' ;

    WHEN OTHERS THEN
         raise_application_error (-20003, 'F_GET_SMT_LINE_CODE RUN NO ='||p_run_no||'  '||SQLERRM);
END;
