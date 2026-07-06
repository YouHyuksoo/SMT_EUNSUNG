FUNCTION "F_GET_PCB_ITEM_BY_NAME" (p_set_item_code IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (20);
BEGIN
    SELECT   child_item_code
      INTO   lvs_return
      FROM   id_eng_bom
     WHERE   parent_item_code = p_set_item_code
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND child_item_code IN (SELECT   item_code
                                   FROM   id_item
                                  WHERE   UPPER (item_name) = 'PCB,MAIN');

    RETURN lvs_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
END;