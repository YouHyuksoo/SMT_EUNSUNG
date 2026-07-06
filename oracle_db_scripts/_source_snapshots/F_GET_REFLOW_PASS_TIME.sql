FUNCTION "F_GET_REFLOW_PASS_TIME" (p_serial_no IN VARCHAR2, p_line_code IN VARCHAR2)
    RETURN DATE
IS
    lvdt_return   DATE;
BEGIN
    SELECT   MIN (receipt_date)
      INTO   lvdt_return
      FROM   iq_interlock_check_result
     WHERE   serial_no = p_serial_no 
       AND line_code = p_line_code
       AND f_get_workstage_type( workstage_code )  = 'REFLOW';

    RETURN lvdt_return;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;