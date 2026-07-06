FUNCTION "F_GET_OQC_INSPECT_HANDLING" 
  ( P_OQC_INSPECT_NO IN varchar2 ,
    p_org in number)
  RETURN  varchar2 IS

LVS_OQC_INSPECT_HANDLING varchar2(1) ;

BEGIN

        select NVL(OQC_INSPECT_HANDLING,'N')
        into LVS_OQC_INSPECT_HANDLING
        from IQ_PRODUCT_OQC_BAD
        where OQC_INSPECT_NO = P_OQC_INSPECT_NO
        AND OQC_INSPECT_HANDLING = 'D'
        and organization_id = p_org
        and rownum = 1 ;

     return LVS_OQC_INSPECT_HANDLING ;

EXCEPTION

   when no_data_found then
     return 'N' ;

   WHEN others THEN

       raise_application_error( -20003 ,P_OQC_INSPECT_NO||' '||sqlerrm ) ;

END;