FUNCTION "F_GET_MODEL_NAME_BY_PID" (p_pid IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (30);

BEGIN
    SELECT   item_code
      INTO   lvs_return
      FROM   ip_product_2d_barcode
     WHERE   serial_no = p_pid;

    RETURN lvs_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
    WHEN OTHERS
    THEN
        RETURN SQLERRM;
END;