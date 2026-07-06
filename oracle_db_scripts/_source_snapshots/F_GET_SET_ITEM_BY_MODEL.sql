FUNCTION "F_GET_SET_ITEM_BY_MODEL" (p_model_name IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (20);
-- Declare program variables as shown above
BEGIN
    SELECT   item_code
      INTO   lvs_return
      FROM   id_item
     WHERE       model_name = UPPER(p_model_name)
             AND set_item_yn = 'Y'
             AND item_division = 'F';

    RETURN lvs_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
END;