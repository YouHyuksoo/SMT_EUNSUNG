FUNCTION "F_GET_NSNP_USE_STATUS" (p_line_code IN VARCHAR2, p_org IN NUMBER)
/* Formatted on 2015-08-05 14:12:57 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_status   VARCHAR2 (10);
BEGIN
    SELECT   use_status
      INTO   lvs_status
      FROM   imcn_machine
     WHERE   line_code = p_line_code AND machine_type = 'NSNP' AND organization_id = p_org;

    RETURN NVL (lvs_status, '*');
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '*';
END;