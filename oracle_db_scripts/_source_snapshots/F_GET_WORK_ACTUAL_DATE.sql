FUNCTION "F_GET_WORK_ACTUAL_DATE" (p_date date,
                                                  p_type varchar2 ) return date is
  Result date;
  lvd_date date;
  LVS_START_TIME VARCHAR2(4) ;
  
begin
  --A : Actual Date
  --S : Plan Start Date
  --E : Plan End Date
  
  
 SELECT START_TIME INTO LVS_START_TIME 
   FROM ICOM_WORKTIME_RANGES 
  WHERE range_type = 'SMTWORKTIME'  AND work_type = 'A' ;
 

  IF LVS_START_TIME = '' OR LVS_START_TIME IS NULL THEN 
  
      LVS_START_TIME := '0830' ;
  
  END IF ;
  

  if p_type = 'A' then
    select DECODE(SIGN(TO_CHAR(p_date,'HH24MI') - LVS_START_TIME),-1,TRUNC(p_date - 1), TRUNC(p_date))
      into Result
      from dual ;
  elsif p_type = 'S' then
    select DECODE(SIGN(TO_CHAR(p_date,'HH24MI') - LVS_START_TIME),-1,TRUNC(p_date - 1), TRUNC(p_date)) + 7/24 + 20/24/60
      into Result
      from dual ;
  elsif p_type = 'E' then
    select DECODE(SIGN(TO_CHAR(p_date,'HH24MI') - LVS_START_TIME),-1,TRUNC(p_date - 1), TRUNC(p_date))
      into lvd_date
      from dual ;

    Result :=  (lvd_date + 1 ) + 8.3332/24  ;

  end if ;


  return(Result);
end F_GET_WORK_ACTUAL_DATE;
