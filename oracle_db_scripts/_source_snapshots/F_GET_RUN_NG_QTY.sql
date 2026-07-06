FUNCTION F_GET_RUN_NG_QTY
(
  P_RUN_NO IN VARCHAR2 
, P_ORG IN NUMBER 
) RETURN NUMBER AS 


LVL_RETURN NUMBER ;

BEGIN

   LVL_RETURN := 0;


   SELECT count(SERIAL_NO)
     INTO LVL_RETURN 
     FROM IP_PRODUCT_WORK_QC
    WHERE RUN_NO          = P_RUN_NO  
      AND ORGANIZATION_ID = P_ORG ;
  
  
/*
    select nvl(sum(lot_qty),0)  
      into LVL_RETURN  
      from ip_product_run_card_io
     where run_no              = P_RUN_NO
       and pcb_item            = 'B'
       and magazine_label_type in ('B,D')
       AND ORGANIZATION_ID     = P_ORG;        -- B:불량, D:폐기
*/      

  RETURN LVL_RETURN;
  
  
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
         RETURN 0 ;
    
END F_GET_RUN_NG_QTY;
