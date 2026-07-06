FUNCTION "F_GET_MAGAZINE_SERIAL" (p_line_code IN VARCHAR2, p_model_name IN VARCHAR2, p_org IN NUMBER)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (30);
    lvi_length   NUMBER;
BEGIN
    BEGIN
        SELECT   magazine_no_length
          INTO   lvi_length
          FROM   ip_product_model_master
         WHERE   model_name = p_model_name
           AND   ORGANIZATION_ID = P_ORG ;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvi_length := 3;
    END;

    IF lvi_length = 3
    THEN
        lvs_return := TO_CHAR (seq_magazine_serial3.NEXTVAL, '000');
    ELSIF lvi_length = 4 THEN
        lvs_return := TO_CHAR (seq_magazine_serial4.NEXTVAL, '0000');

    ELSE
        lvs_return := TO_CHAR (seq_magazine_serial5.NEXTVAL, '00000');
    END IF;

    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '*';
END;