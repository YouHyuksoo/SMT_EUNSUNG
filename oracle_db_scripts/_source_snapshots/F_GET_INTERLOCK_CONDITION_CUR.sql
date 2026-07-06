FUNCTION "F_GET_INTERLOCK_CONDITION_CUR" (p_line_code        IN VARCHAR2,
                                        p_workstage_code   IN VARCHAR2,
                                        p_machine_code     IN VARCHAR2,
                                        p_pid              IN VARCHAR2)
    RETURN sys_refcursor
IS
    o_cursor        sys_refcursor;
    lvs_item_code   VARCHAR2 (30);
BEGIN

    OPEN o_cursor FOR
          SELECT   interlock_check_type, check_sequence
            FROM   iq_interlock_check_condition
           WHERE   line_code = p_line_code 
             AND workstage_code = p_workstage_code  
             AND NVL (use_yn, 'Y') = 'Y'
        ORDER BY   check_sequence ASC;

    RETURN o_cursor;
END;