FUNCTION "F_GET_LOCATION_QTY" (p_parent_item_code   IN VARCHAR2,
/* Formatted on 2013-01-17 16:31:35 (QP5 v5.126) */
                             p_child_item_code    IN VARCHAR2,
                             p_line_code          IN VARCHAR2,
                             p_org                IN NUMBER)
    RETURN NUMBER
IS
    lvl_return   NUMBER;
BEGIN
    SELECT   COUNT ( * )
      INTO   lvl_return
      FROM   id_eng_bom_smt
     WHERE       parent_item_code = p_parent_item_code
             AND child_item_code = p_child_item_code
             AND line_code = p_line_code
             AND organization_id = p_org;

    RETURN lvl_return;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;