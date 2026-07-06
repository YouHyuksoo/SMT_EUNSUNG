FUNCTION "F_GET_ORG_NAME" (p_org number) return varchar2 is
  Result varchar2(50);
begin
  select x.organization_full_name_eng
    into result 
    from isys_organization x 
   where x.organization_id = p_org ; 
  return(Result);
end F_GET_ORG_NAME;