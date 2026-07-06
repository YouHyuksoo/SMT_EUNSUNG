FUNCTION F_GET_PID_SMD_AOI (
   p_pid         IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvl_cnt                       NUMBER;
BEGIN
     
   select count(*)
     into lvl_cnt  
     from iq_machine_inspect_data_aoi  
    where PID             like p_pid 
      AND ORGANIZATION_ID = p_org;
                  
   RETURN lvl_cnt;
      
EXCEPTION
   WHEN OTHERS THEN
        return 0;
END;