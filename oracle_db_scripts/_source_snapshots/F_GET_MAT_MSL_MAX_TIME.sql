FUNCTION "F_GET_MAT_MSL_MAX_TIME" (p_item_code IN VARCHAR2)
/* Formatted on 2015-04-19 14:38:50 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvl_max_time   NUMBER;
BEGIN
    SELECT   NVL(msl_max_time,0)
      INTO   lvl_max_time
      FROM   id_item
     WHERE   item_code = p_item_code AND NVL (msl_level, '0') <> '0';

    RETURN lvl_max_time;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
END;