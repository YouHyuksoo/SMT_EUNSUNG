FUNCTION "F_GET_CUSTOMER_MODEL_NAME_CUR" (p_customer_code IN VARCHAR2
/* Formatted on 2015-04-01 15:11:08 (QP5 v5.126) */,
                                                         p_org IN NUMBER)
  RETURN sys_refcursor IS
  o_cursor sys_refcursor;
BEGIN
  OPEN o_cursor FOR
    SELECT MODEL_NAME
      FROM ip_product_model_master
     WHERE customer_code = p_customer_code
       AND organization_id = p_org
    ORDER BY MODEL_NAME;

  RETURN o_cursor;
END;