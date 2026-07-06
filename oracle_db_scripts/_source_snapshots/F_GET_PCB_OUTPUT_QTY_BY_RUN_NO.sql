FUNCTION "F_GET_PCB_OUTPUT_QTY_BY_RUN_NO" (p_run_no IN VARCHAR2, p_org IN NUMBER)
   RETURN NUMBER
IS
   lvl_return   NUMBER;
BEGIN
  
 --  SELECT COUNT (*)
 --    INTO lvl_return
 --    FROM IQ_INTERLOCK_CHECK_RESULT
 --   WHERE run_no          = p_run_no
 --     and  MACHINE_CODE   = ''
  --    AND organization_id = p_org;
      
   SELECT COUNT (*)
     INTO lvl_return
     FROM Iq_Machine_Inspect_Data_Aoi
    WHERE run_no          = p_run_no
      AND organization_id = p_org;      

   RETURN lvl_return;
   
EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN 0;
   WHEN OTHERS THEN
        raise_application_error (-20003, SQLERRM);
END;
