FUNCTION f_get_model_name_by_run_no (p_run_no IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (30);

BEGIN
    SELECT   model_name
      INTO   lvs_return
      FROM   ip_product_run_card
     WHERE   run_no = p_run_no ;

    RETURN lvs_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
    WHEN OTHERS
    THEN
        RETURN SQLERRM;
END;
