FUNCTION "F_GET_SMT_MODDEL_NAME_4_INOUT" ( 
                                                            p_model_name IN varchar2, 
                                                            p_org        in number
                                                           )
RETURN  varchar2 IS

    lvs_smt_model_name varchar2(50) ;

BEGIN
  
    select max(smt_model_name)
      into lvs_smt_model_name
      from ib_product_plandata
     where model_name      = p_model_name
       and organization_id = p_org ;
       
    RETURN lvs_smt_model_name  ;
    
EXCEPTION
   WHEN others THEN
        return '*'  ;
END;
