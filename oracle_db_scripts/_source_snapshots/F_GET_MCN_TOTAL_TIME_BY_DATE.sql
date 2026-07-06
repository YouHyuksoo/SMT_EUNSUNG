FUNCTION "F_GET_MCN_TOTAL_TIME_BY_DATE" (p_machine_code IN VARCHAR2, p_date in date , p_org IN NUMBER)
   RETURN NUMBER
IS
   lvf_op_time   NUMBER;
BEGIN
   SELECT SUM (total_operation_time)
     INTO lvf_op_time
     FROM imcn_machine_daily_operation
    WHERE machine_code = p_machine_code
      AND plan_date = p_date
      AND machine_status_code <> 'S'                                  -- START
      AND organization_id = p_org;

   RETURN lvf_op_time;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;