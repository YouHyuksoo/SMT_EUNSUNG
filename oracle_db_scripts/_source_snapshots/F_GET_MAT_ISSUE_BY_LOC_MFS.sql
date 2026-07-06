FUNCTION "F_GET_MAT_ISSUE_BY_LOC_MFS" (p_item_code       IN VARCHAR2,
                                                       p_material_mfs    IN VARCHAR2,
                                                       p_location_code   IN VARCHAR2,
                                                       p_org             IN NUMBER)
    RETURN NUMBER
IS
    -----------------------------------------------------------
    lvdt_issue_qty   NUMBER;
BEGIN
    SELECT   SUM (issue_qty)
      INTO   lvdt_issue_qty
      FROM   im_item_issue
     WHERE   item_code = p_item_code
         AND material_mfs = p_material_mfs
         AND location_code = p_location_code
         AND organization_id = p_org;

    RETURN NVL (lvdt_issue_qty, 0);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN NULL;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;