FUNCTION f_get_customer_model_by_run_no (p_run_no IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (30);

BEGIN
    SELECT   customer_model_name
      INTO   lvs_return
      FROM   ip_product_model_master
     WHERE   model_name = ( select model_name from ip_Product_run_card where run_no = p_run_no ) ;

    RETURN lvs_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
    WHEN OTHERS
    THEN
        RETURN SQLERRM;
END;