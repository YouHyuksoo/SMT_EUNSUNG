FUNCTION "F_GET_WORK_BREAKTIME_MIN" (
                                                        p_start_time date,
                                                        p_end_time   date 
                                                      ) 
return number is
  lvl_Result number;
  
  lvs_start varchar2(20);
  lvs_end   varchar2(20);
  
begin
  
   select to_char(trunc(sysdate) + decode(sign(to_char(p_start_time, 'HH24MI') - '0830'),-1,1,0),'YYYYMMDD')||to_char(p_start_time, 'HH24MI'),
          to_char(trunc(sysdate) + decode(sign(to_char(p_end_time, 'HH24MI') - '0830'),-1,1,0,1,0),'YYYYMMDD')||to_char(p_end_time, 'HH24MI')
     into lvs_start, lvs_end
    from dual; 
           
   lvl_Result := 0;
   
   select nvl( sum( decode( attribute03, 0, 0, (to_date(R_END_TIME, 'YYYYMMDDHH24MISS') - to_date(R_START_TIME, 'YYYYMMDDHH24MISS'))*(24*60) ) ), 0)
     into lvl_Result
     from (   
             select start_time, end_time, attribute03,
                    DECODE( SIGN( (to_char(trunc(sysdate) + decode(sign(start_time - '0830'),-1,1,0),'YYYYMMDD')||start_time) - lvs_start ), -1, lvs_start, (to_char(trunc(sysdate) + decode(sign(start_time - '0830'),-1,1,0),'YYYYMMDD')||start_time) ) AS R_START_TIME, 
                    DECODE( SIGN( lvs_end - (to_char(trunc(sysdate) + decode(sign(end_time - '0830'),-1,1,0,1,0),'YYYYMMDD')||end_time) ), 1, (to_char(trunc(sysdate) + decode(sign(end_time - '0830'),-1,1,0,1,0),'YYYYMMDD')||end_time), lvs_end )        AS R_END_TIME 
               from icom_worktime_ranges
              where range_type = 'BRAEKTIME'
                and to_char(trunc(sysdate) + decode(sign(start_time - '0830'),-1,1,0),'YYYYMMDD') || start_time   <= lvs_end
                and to_char(trunc(sysdate) + decode(sign(end_time   - '0830'),-1,1,0,1,0),'YYYYMMDD') || end_time >= lvs_start
          );
        
  return lvl_Result;

exception
  when others then
       return 0;
end ;      
