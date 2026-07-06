FUNCTION "F_GET_LINE_MACHINE_CUR" (p_line_code IN VARCHAR2, p_org IN NUMBER)
  RETURN sys_refcursor IS
  o_cursor sys_refcursor;
BEGIN
  OPEN o_cursor FOR
    SELECT MACHINE_CODE
      FROM imcn_machine
     WHERE organization_id = p_org
       AND LINE_CODE = p_line_code
  ORDER BY MACHINE_CODE ;

  RETURN o_cursor;
END;