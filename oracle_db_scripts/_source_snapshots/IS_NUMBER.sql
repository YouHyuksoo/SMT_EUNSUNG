FUNCTION "IS_NUMBER" (p_data varchar2) return varchar2 is
  Result varchar2(1);

begin
  
 
  
 
  IF REGEXP_INSTR(p_data,'[^0-9]') = 0  THEN 
    RETURN 'Y' ; 

    
  ELSE 
    RETURN 'N' ; 
  END IF ; 


end IS_NUMBER;