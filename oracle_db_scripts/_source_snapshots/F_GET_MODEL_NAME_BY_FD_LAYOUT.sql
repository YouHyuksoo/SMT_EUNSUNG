FUNCTION "F_GET_MODEL_NAME_BY_FD_LAYOUT" 
  ( p_feeder_layoud_Name IN varchar2)
  RETURN  varchar2 IS

    lvs_model_name   VARCHAR2(30);
   
BEGIN
         BEGIN

           SELECT MAX(MODEL_NAME)
             INTO lvs_model_name
             FROM IP_PRODUCT_model_master
            WHERE smt_model_name = f_get_smt_moddel_name_4_inout( p_feeder_layoud_Name , organization_id ) ;

         EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                     lvs_model_name := '';
         END;
   
     RETURN lvs_model_name ;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '*';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;