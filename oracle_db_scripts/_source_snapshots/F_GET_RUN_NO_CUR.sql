FUNCTION "F_GET_RUN_NO_CUR" 
  RETURN sys_refcursor IS
  o_cursor sys_refcursor;
BEGIN
  OPEN o_cursor FOR
    SELECT RUN_NO
      FROM IP_PRODUCT_RUN_CARD
     WHERE RUN_DATE >= SYSDATE -3
  ORDER BY RUN_NO ;

  RETURN o_cursor;
END;