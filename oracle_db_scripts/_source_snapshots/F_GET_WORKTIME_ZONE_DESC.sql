FUNCTION "F_GET_WORKTIME_ZONE_DESC" (p_worktype varchar2 ) return varchar2 is
  Result varchar2(20);
begin

  select start_time||'~'||end_time
     into result
     from icom_worktime_ranges x
    where work_type = p_worktype ;


  return(Result);

exception
  when others then
    return('NOT DEFINED');
end F_GET_WORKTIME_ZONE_DESC;