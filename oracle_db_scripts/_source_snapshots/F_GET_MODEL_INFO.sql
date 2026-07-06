FUNCTION "F_GET_MODEL_INFO" (p_model_name IN VARCHAR2, p_org IN NUMBER, p_type in varchar2 default 'MODEL_SPEC' )
   RETURN varchar2
IS
   lvs_return   varchar2(50);
BEGIN

     SELECT decode(p_type, 'MODEL_SPEC', model_spec ,
                           'PART_NO'   , part_no,
                           'CUSTOMER_CODE', customer_code,
                           'ITEM_CODE' , item_code,
                           'CUSTOMER_MODEL_NAME', customer_model_name ,
                           'SOLDER_ITEM_CODE',solder_item_code,
                           'SMT_MODEL_NAME', smt_model_name,
                           'MASTER_MODEL_NAME',master_model_name,
                           'SW_VERSION',sw_version,
                           'HW_VERSION',hw_version,
                           'INDEX',sw_filename,
                           model_name )
       INTO lvs_return
       FROM ip_product_model_master
      WHERE item_code = p_model_name
        AND organization_id = p_org;

   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS THEN
      RETURN 'ERR';
END;
