FUNCTION "F_GET_MODEL_NAME_CUR" 
/* Formatted on 2015-04-01 15:11:08 (QP5 v5.126) */
    RETURN sys_refcursor
IS
    o_cursor   sys_refcursor;
BEGIN
    OPEN o_cursor FOR SELECT   model_name FROM ip_product_model_master;

    RETURN o_cursor;
END;