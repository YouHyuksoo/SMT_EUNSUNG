FUNCTION "F_GET_PCB_REPAIR_YN" (p_serial_no   IN VARCHAR2,
/* Formatted on 2012/10/30 15:08:29 (QP5 v5.126) */
                                               p_org         IN NUMBER)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (1);
    lvi_count    NUMBER;
BEGIN
    SELECT   COUNT ( * )
      INTO   lvi_count
      FROM   ip_product_work_qc
     WHERE   serial_no = p_serial_no AND organization_id = p_org;

    IF lvi_count > 0
    THEN
        RETURN 'Y';
    ELSE
        RETURN 'N';
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 'N';
END;