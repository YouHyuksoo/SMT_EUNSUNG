FUNCTION "F_GET_WORK_LOSSTIME_MIN" (
                                                        p_line_code  varchar2,
                                                        p_start_time date,
                                                        p_end_time   date 
                                                      ) 
return number is
  lvl_Result number;
  
begin
  
   select NVL( SUM( DECODE( p_start_time, NULL, 0, DECODE( p_end_time, NULL, 0, (( DECODE( SIGN(p_end_time - END_TIME), 1, END_TIME, p_end_time)  - DECODE( SIGN(START_TIME - p_start_time), -1, p_start_time, START_TIME) ) * (24*60)) ) ) ) ,0)          
     into lvl_Result
     from IMCN_MACHINE_DAILY_OPERATION
    where line_code  =  p_line_code
      and start_time <= p_end_time
      and end_time   >= p_start_time;
             
        
  return lvl_Result;

exception
  when others then
       return 0;
end ;      
