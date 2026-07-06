FUNCTION F_GET_PID_JIG (
   p_pid         IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvl_cnt                       NUMBER;
BEGIN
     
   select count(*)
     into lvl_cnt  
     from imcn_jig_input_hist  
    where run_no = (
                           select run_no
                              from ip_product_2d_barcode
                            where serial_no like p_pid
                                and rownum = 1
                   ) 
   AND ORGANIZATION_ID = p_org; 
                  
   RETURN lvl_cnt;
      
EXCEPTION
   WHEN OTHERS THEN
        return 0;
END;
