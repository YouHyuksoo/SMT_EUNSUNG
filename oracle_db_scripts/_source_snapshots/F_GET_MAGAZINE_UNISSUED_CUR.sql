FUNCTION "F_GET_MAGAZINE_UNISSUED_CUR" (p_line_code IN VARCHAR2,
/* Formatted on 2015-07-17 15:11:08 (QP5 v5.126) */
                                                   p_workstage_code   IN     VARCHAR2,
                                                   p_machine_code     IN     VARCHAR2,
                                                   p_model_name       IN     VARCHAR2,
                                                   p_item_code        IN     VARCHAR2,
                                                   p_org IN NUMBER)
  RETURN sys_refcursor
IS
  o_cursor sys_refcursor;
BEGIN
  OPEN o_cursor FOR
    SELECT SERIAL_NO
      FROM iq_interlock_check_result
     WHERE line_code = p_line_code
       AND workstage_code = p_workstage_code
       AND machine_code = p_machine_code
       AND model_name = p_model_name
       AND item_code = p_item_code
       AND organization_id = p_org
       AND magazine_no = '*'
       AND RECEIPT_DATE >= sysdate - 1
     ORDER BY RECEIPT_DATE;

  RETURN o_cursor;
END;