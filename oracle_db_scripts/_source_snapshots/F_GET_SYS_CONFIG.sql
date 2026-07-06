FUNCTION "F_GET_SYS_CONFIG" (p_config_name varchar2, p_org_id number ) return varchar2 is
  Result varchar2(50);
begin
  
  select x.config_value
    into Result 
    from isys_config x 
   where x.config_name = p_config_name  
   and organization_id = p_org_id ; 

  return(Result);
exception 
  when others then 
    return 'NULL';
    
end F_GET_SYS_CONFIG;