FUNCTION "F_GET_ECO_ITEM_CHECK" (p_line_code IN VARCHAR2, p_model_name IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return      VARCHAR2 (10);
    lvs_item_code   VARCHAR2 (30);
BEGIN
    SELECT   MAX (item_code)
      INTO   lvs_item_code
      FROM   ib_product_plandata
     WHERE   line_code = p_line_code
         AND model_name = p_model_name
         AND item_code IN (SELECT   item_code
                             FROM   id_item
                            WHERE   eco_check_yn = 'Y')
         AND active_yn = 'Y';


    RETURN lvs_item_code;


EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;