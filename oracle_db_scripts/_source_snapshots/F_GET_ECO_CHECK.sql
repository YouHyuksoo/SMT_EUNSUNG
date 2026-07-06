FUNCTION "F_GET_ECO_CHECK" (p_line_code IN VARCHAR2, p_model_name IN VARCHAR2)
/* Formatted on 2015-05-09 10:25:02 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvs_return   VARCHAR2 (10);
    lvi_count    NUMBER;
BEGIN
    SELECT   COUNT ( * )
      INTO   lvi_count
      FROM   ib_product_plandata
     WHERE   line_code = p_line_code
         AND model_name = p_model_name
         AND item_code IN (SELECT   item_code
                             FROM   id_item
                            WHERE   eco_check_yn = 'Y')
         AND active_yn = 'Y';


    IF lvi_count > 0
    THEN
        RETURN lvi_count;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;