FUNCTION "F_GET_WORKSTAGE_TYPE" (p_workstage IN VARCHAR2)
/* Formatted on 2013-01-21 ??? 1:38:55 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (30);
BEGIN
    SELECT   workstage_type
      INTO   lvs_return
      FROM   ip_product_workstage
     WHERE   workstage_code = p_workstage;

    IF lvs_return IS NULL
    THEN
        RETURN p_workstage;
    ELSE
        RETURN lvs_return;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '';
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;