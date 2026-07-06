FUNCTION "F_GET_MSL_LEVEL" (p_item_code IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (10);
BEGIN

    SELECT msl_level
      INTO lvs_return
      FROM id_item
     WHERE item_code = p_item_code;

    RETURN lvs_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '';
END;