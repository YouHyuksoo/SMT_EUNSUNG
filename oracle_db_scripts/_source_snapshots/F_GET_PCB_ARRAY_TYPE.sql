FUNCTION "F_GET_PCB_ARRAY_TYPE" (
   p_model_name   IN   VARCHAR2,
   p_org          IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvl_return  VARCHAR2(20) ;
BEGIN

  
   SELECT array_type
     INTO lvl_return
     FROM ip_product_model_master
    WHERE model_name = p_model_name AND organization_id = p_org;

   RETURN lvl_return;
   
EXCEPTION
   when no_data_found then
       raise_application_error (-20003, p_model_name||'  모델마스터 미등록 모델입니다.모델마스터에 먼저 등록하세요');
   WHEN OTHERS
   THEN
      raise_application_error (-20003, p_model_name||'  '||SQLERRM);
END;