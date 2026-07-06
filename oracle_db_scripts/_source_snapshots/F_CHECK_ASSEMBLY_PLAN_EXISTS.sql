FUNCTION "F_CHECK_ASSEMBLY_PLAN_EXISTS" ( p_mfs IN varchar2 ,p_org In number )

  RETURN  varchar2 IS


lvi_count number;

BEGIN

    select count(*) into lvi_count
      from ip_product_smd_plan
     where mfs = p_mfs
       and organization_id = p_org ;

    if lvi_count > 0 then
       return 'Y' ;


    else
       return 'N'  ;
    end if ;


EXCEPTION
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;