FUNCTION F_GET_PID_IMD_AOI2 (
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
      AND ORGANIZATION_ID = p_org
      AND MACHINE_CODE = 'AOI MASS_W080' ;
                  
   RETURN lvl_cnt;
      
EXCEPTION
   WHEN OTHERS THEN
        return 0;
END;