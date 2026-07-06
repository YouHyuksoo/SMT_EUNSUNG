FUNCTION F_GET_PID_WORKQC (
   p_pid         IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvl_cnt                       NUMBER;
BEGIN

     
   select count(*)
     into lvl_cnt 
     from ip_product_work_qc
    where serial_no       like p_pid 
      AND ORGANIZATION_ID = p_org;
   
                
   RETURN lvl_cnt;
      
EXCEPTION
   WHEN OTHERS THEN
        return 0;
END;
