FUNCTION "F_GET_INSPECT_PROCESS" 
  ( p_item_code IN varchar2 ,p_org in number)
  RETURN  varchar2 IS

lvs_inspect_process varchar2(20) ;


BEGIN
     RETURN '' ;

     select distinct inspect_process
        into lvs_inspect_process
        from IQ_ITEM_OQC_CRITERION
        where item_code = p_item_code
        and organization_id = p_org ;

     return lvs_inspect_process ;

EXCEPTION

   when no_data_found then
     return '' ;

   WHEN others THEN

       raise_application_error( -20003 ,p_item_code||' '||sqlerrm ) ;

END;