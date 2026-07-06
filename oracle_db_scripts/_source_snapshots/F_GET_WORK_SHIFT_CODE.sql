FUNCTION "F_GET_WORK_SHIFT_CODE" (p_date in date) return varchar2 is
  Result varchar2(1);
  LVS_START_TIME VARCHAR2(10) ;
  LVS_END_TIME VARCHAR2(10) ;
begin


 SELECT START_TIME INTO LVS_START_TIME 
   FROM ICOM_WORKTIME_RANGES 
  WHERE range_type = 'SMTWORKTIME'  AND work_type = 'A' ;
 

  IF LVS_START_TIME = '' OR LVS_START_TIME IS NULL THEN 
      LVS_START_TIME := '0830' ;
  END IF ;
  
  
   SELECT START_TIME INTO LVS_END_TIME 
   FROM ICOM_WORKTIME_RANGES 
  WHERE range_type = 'SMTWORKTIME'  AND work_type = 'E' ;
 

  IF LVS_END_TIME = '' OR LVS_END_TIME IS NULL THEN 
      LVS_END_TIME := '2030' ;
  END IF ;
  
  
  if to_char(p_date,'hh24mi') >= LVS_START_TIME AND to_char(p_date,'hh24mi') < LVS_END_TIME then
    Result := 'A';
  else
    Result := 'B';
  end if;

  return(Result);
end F_GET_WORK_SHIFT_CODE;
