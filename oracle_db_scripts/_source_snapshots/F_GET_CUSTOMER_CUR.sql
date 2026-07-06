FUNCTION "F_GET_CUSTOMER_CUR" (p_org IN NUMBER)
  RETURN sys_refcursor IS
  o_cursor sys_refcursor;
BEGIN
  OPEN o_cursor FOR
    SELECT customer_code, customer_name, customer_name_eng
      FROM icom_customer
     WHERE organization_id = p_org
       AND customer_code <> '*';

  RETURN o_cursor;
END;