function F_GET_ITEM_NAME(p_organization_id number,
                                           p_partno varchar2) return varchar2 is
  Result varchar2(100);
begin
  SELECT x.model_name
    INTO Result
    FROM IP_PRODUCT_MODEL_MASTER  X
   WHERE ORGANIZATION_ID = p_organization_id
     AND X.ITEM_CODE     = p_partno ;



  return(Result);
  
exception
  when no_data_found then
    return 'NONE' ;
end F_GET_ITEM_NAME;
