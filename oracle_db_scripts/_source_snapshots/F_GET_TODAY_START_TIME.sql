FUNCTION "F_GET_TODAY_START_TIME" (p_date date)
return date is
  
lvd_date date;
LVS_START_TIME VARCHAR2(10) ;  
begin

  
 SELECT START_TIME INTO LVS_START_TIME 
   FROM ICOM_WORKTIME_RANGES 
  WHERE range_type = 'SMTWORKTIME'  AND work_type = 'A' ;
 

  IF LVS_START_TIME = '' OR LVS_START_TIME IS NULL THEN 
        LVS_START_TIME := '0830' ;
  END IF ;
  
    select DECODE(SIGN(TO_CHAR(p_date,'HH24MI') - LVS_START_TIME),-1,  to_date( TO_CHAR(p_date - 1 , 'YYYYMMDD')||LVS_START_TIME  , 'yyyymmddhh24miss') ,  to_date( TO_CHAR(p_date  , 'YYYYMMDD')||LVS_START_TIME  , 'yyyymmddhh24miss')    )
      into lvd_date
      from dual ;
 
  return lvd_date ;

end ;
