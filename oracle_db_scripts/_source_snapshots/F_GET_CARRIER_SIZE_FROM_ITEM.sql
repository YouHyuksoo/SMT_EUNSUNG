FUNCTION "F_GET_CARRIER_SIZE_FROM_ITEM" (p_model_name IN VARCHAR2, p_org IN NUMBER)
/* Formatted on 2015-08-04 21:59:22 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvl_return   NUMBER;
BEGIN
    SELECT   MAX (carrier_size)
      INTO   lvl_return
      FROM   id_item
     WHERE   model_name = p_model_name AND organization_id = p_org;


    IF NVL(lvl_return,0) = 0
    THEN
        RETURN 2;
    ELSE
        RETURN lvl_return;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 2;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;