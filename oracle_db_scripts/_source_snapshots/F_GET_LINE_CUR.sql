FUNCTION "F_GET_LINE_CUR" (p_org IN NUMBER)
  RETURN sys_refcursor IS
  o_cursor sys_refcursor;
BEGIN
  OPEN o_cursor FOR
    SELECT LINE_CODE
      FROM imcn_machine
     WHERE organization_id = p_org
       AND LINE_CODE <> '*'
  GROUP BY LINE_CODE
  ORDER BY LINE_CODE ;

  RETURN o_cursor;
END;