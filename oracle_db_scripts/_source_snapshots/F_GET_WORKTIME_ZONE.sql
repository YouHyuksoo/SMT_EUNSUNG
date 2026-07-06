FUNCTION "F_GET_WORKTIME_ZONE" (p_date   varchar2,
                                                  p_time   varchar2,
                                                  p_option varchar2 default 'ZONE' 
                                                 ) return  varchar2 is
  Result varchar2(5);
  LVS_DATE VARCHAR(8);
begin

  if p_time >= '0000' AND p_time < '0830' THEN

    select work_type
      into Result
      from icom_worktime_ranges x
     where ( to_date(start_time,'HH24MI') + NVL(TO_NUMBER(x.attribute01),0)) <= to_date(p_time,'hh24mi')  + 1
       and ( to_date(end_time,'HH24MI')   + NVL(TO_NUMBER(x.attribute02),0)) >  to_date(p_time,'hh24mi')  + 1
       and range_type = 'WORKTIME'  ;

    LVS_DATE := TO_CHAR(to_date(p_date,'yyyymmdd') - 1 , 'YYYYMMDD') ;
    
  else
    
    select work_type
      into Result
      from icom_worktime_ranges x
     where ( to_date(start_time,'HH24MI') + NVL(TO_NUMBER(x.attribute01),0)) <= to_date(p_time,'hh24mi')
       and ( to_date(end_time,'HH24MI')   + NVL(TO_NUMBER(x.attribute02),0)) >  to_date(p_time,'hh24mi')
       and range_type = 'WORKTIME'  ;

    LVS_DATE := p_date ;
    
  end if ;

  if p_option = 'ZONE' then
    return(Result);
  else
    return LVS_DATE;
  end if;

exception
  when others then
    
    if p_option = 'ZONE' then
       return('Z');
    else
      return p_date ;
    end if;

end ;
