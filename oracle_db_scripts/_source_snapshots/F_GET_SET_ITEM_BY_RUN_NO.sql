FUNCTION "F_GET_SET_ITEM_BY_RUN_NO" (p_run_no IN VARCHAR2)
/* Formatted on 2013/1/12 23:06:57 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (20);
-- Declare program variables as shown above
BEGIN
    SELECT   item_code
      INTO   lvs_return
      FROM   id_item
     WHERE   model_name = (SELECT   model_name
                             FROM   ip_product_run_card
                            WHERE   run_no = p_run_no)
             AND set_iteM_yn = 'Y'
             and item_division = 'F' ;

    RETURN lvs_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
END;
/*ADVICE(24): END of program unit, package or type is not labeled [408] */