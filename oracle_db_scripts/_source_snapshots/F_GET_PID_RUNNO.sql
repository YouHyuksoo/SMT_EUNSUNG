FUNCTION F_GET_PID_RUNNO (
   p_pid         IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvl_cnt                       NUMBER;
BEGIN

     
   select count(*)
     into lvl_cnt
     from ip_product_run_card
    where run_no = (
                            select run_no   
                             from ip_product_2d_barcode  
                           where SERIAL_NO        like p_pid 
                              AND ORGANIZATION_ID = p_org
                              AND ROWNUM = 1
                   );
                         
   
   RETURN lvl_cnt;
      
EXCEPTION
   WHEN OTHERS THEN
        return 0;
END;
