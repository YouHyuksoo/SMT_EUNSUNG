FUNCTION "F_CHECK_PID_STATUS_4_WS" (p_pid varchar2) return varchar2 is

  lvi_defect number;
  lvi_pack number; 
  /**********************************************
  * PID 의 상태를 반환 한다. 
  * 1.수리품인지 
  * 2.패킹된 제품인지 2018.05.13
  ***********************************************/
begin

 select count(*)
   into lvi_defect
   from ip_product_work_qc
  where serial_no = p_pid    
    and receipt_deficit = 1  
  ;

 if lvi_defect > 0 then
   return '9204' ;   --수리실에서 미 출고된 시리얼 입니다. 
   --수리품 메시지 
 end if ;
 
 SELECT COUNT(*) 
   INTO lvi_pack 
   FROM IP_PRODUCT_PACK_SERIAL X 
  WHERE X.BARCODE = P_PID 
 ; 
 
 if lvi_pack > 0 then 
   return '9205';  --이미 패킹이된 시리얼 입니다. 
 end if ;
 
 return 'OK' ;


end F_CHECK_PID_STATUS_4_WS;
