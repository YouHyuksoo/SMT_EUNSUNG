FUNCTION "F_TEST_INTERLOCK_CONDITION_CUR" (p_1        IN VARCHAR2,
/* Formatted on 2015-04-07 13:27:50 (QP5 v5.126) */
                                        p_2   IN VARCHAR2,
                                        p_3     IN VARCHAR2,
                                        p_4              IN VARCHAR2)
    RETURN sys_refcursor
IS
    o_cursor        sys_refcursor;
    lvs_item_code   VARCHAR2 (30);
BEGIN
    --lvs_item_code := f_get_model_name_by_pid (p_4);

    OPEN o_cursor FOR
        SELECT   interlock_check_type, check_sequence
          FROM   iq_interlock_check_condition
         WHERE   line_code = p_1 AND machine_code = p_3
         ORDER BY check_sequence ASC ;       --AND item_code = lvs_item_code;

    RETURN o_cursor;
END;