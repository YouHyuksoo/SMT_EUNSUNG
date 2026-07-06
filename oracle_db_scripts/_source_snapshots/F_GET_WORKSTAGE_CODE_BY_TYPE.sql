FUNCTION "F_GET_WORKSTAGE_CODE_BY_TYPE" (p_workstage_type IN VARCHAR2)
/* Formatted on 2013-01-07 16:57:58 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (30);
BEGIN
    SELECT   workstage_code INTO lvs_return
    FROM ip_product_workstage
    WHERE WORKSTAGE_TYPE = p_workstage_type
      and rownum = 1 ;

    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN p_workstage_type;
END;