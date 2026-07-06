FUNCTION "F_GET_WORKTIME_SEC" (p_start_time date,
                                                 p_end_time   date ) 
return number is
  lvl_Result number;
  
  lvs_start varchar2(10);
  lvs_end   varchar2(10);
  
begin
  
   lvs_start := to_char(p_start_time, 'HH24MI');
   lvs_end   := to_char(p_end_time, 'HH24MI');
   
   
   SELECT SUM( ( TO_DATE( R_END_TIME, 'hh24mi') - TO_DATE( R_START_TIME, 'HH24MI') ) * 24 * 60 * 60 ) 
     INTO LVL_RESULT 
     FROM
          (  
                select START_TIME, 
                       END_TIME  , 
                       DECODE( SIGN(START_TIME - lvs_start), -1, lvs_start, START_TIME) AS R_START_TIME , 
                       DECODE( SIGN(lvs_end- END_TIME), 1, END_TIME, lvs_end)       AS R_END_TIME 
                  from IP_PRODUCT_WORK_TIME t
                 where  start_time   <=lvs_end  --종료 시간 
                   and  end_time     >= lvs_start  --시작시간         
                   and work_date     = f_get_work_actual_date(sysdate,'A')
                   and time_division <> 'R' 
           ) ; 
   
   /*
   select sum(time_diff) * 24 *60 *60
     into lvl_Result
    from (
          select nvl(to_date(to_char(sysdate, 'YYYYMMDD')||end_time,'YYYYMMDDHH24MISS')  - to_date(to_char(sysdate, 'YYYYMMDD')||lvs_start,'YYYYMMDDHH24MISS'),0) time_diff
            from ICOM_WORKTIME_RANGES
           where start_time <  lvs_start
             and end_time   >= lvs_start
             and range_type = 'MAIN LINE TARGET'
             and organization_id = 1
           union all
          select nvl(to_date(to_char(sysdate, 'YYYYMMDD')||end_time,'YYYYMMDDHH24MISS') -  to_date(to_char(sysdate, 'YYYYMMDD')||start_time,'YYYYMMDDHH24MISS'),0)  time_diff
            from ICOM_WORKTIME_RANGES
           where start_time >= lvs_start
             and end_time   <= lvs_end  
             and range_type = 'MAIN LINE TARGET'
             and organization_id = 1
           union all 
          select nvl(to_date(to_char(sysdate, 'YYYYMMDD')||lvs_end,'YYYYMMDDHH24MISS') - to_date(to_char(sysdate, 'YYYYMMDD')||start_time,'YYYYMMDDHH24MISS'),0) time_diff
            from ICOM_WORKTIME_RANGES
           where start_time <= lvs_end
             and end_time   >  lvs_end 
             and range_type = 'MAIN LINE TARGET'
             and organization_id = 1
         );
     */
        
  return lvl_Result;

exception
  when others then
       return 0;
end ;      
