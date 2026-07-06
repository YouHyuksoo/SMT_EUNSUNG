FUNCTION "F_GET_WORKSTAGE_PASS_TIME" (p_line_code        IN VARCHAR2,
                                                      p_workstage_code   IN VARCHAR2,
                                                      p_run_no           IN VARCHAR)
    RETURN date
IS
    lvdt_date   DATE;
BEGIN
    SELECT   MAX (receipt_date)
      INTO   lvdt_date
      FROM   iq_interlock_check_result
     WHERE   line_code = p_line_code AND workstage_code = p_workstage_code AND run_no = p_run_no;

    RETURN lvdt_date;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN NULL;
END;