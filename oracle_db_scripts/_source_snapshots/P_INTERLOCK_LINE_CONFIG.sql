PROCEDURE "P_INTERLOCK_LINE_CONFIG" (p_line_code      IN     VARCHAR2,
/* Formatted on 2015-07-12 15:51:26 (QP5 v5.126) */
                                   p_machine_code   IN     VARCHAR2,
                                   p_config         IN     VARCHAR2,
                                   p_out               OUT VARCHAR2)
IS
    lvs_return                 VARCHAR2 (30);

    lvs_dio_port               VARCHAR2 (30);
    lvs_scanner_port           VARCHAR2 (30);
    lvs_equipment_port         VARCHAR2 (30);
    lvs_dio_address            VARCHAR2 (30);
    lvs_bcr_code               VARCHAR2 (30);
    lvs_buffer_type            VARCHAR2 (30);
    lvs_workstage_code         VARCHAR2 (30);
    lvs_workstage_name         VARCHAR2 (30);
    lvf_process_process_time   NUMBER;
    lvs_scanner_address        VARCHAR2 (30);
    lvs_process_wait_time      VARCHAR2 (30);
BEGIN
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------

    SELECT   NVL (a.dio_port, 'N'),
             NVL (a.scanner_port, 'N'),
             NVL (a.equipment_port, 'N'),
             a.dio_address,
             a.bcr_code,
             a.buffer_type,
             a.workstage_code,                                                                         -- workstage code
             b.workstage_name,
             a.process_wait_time,
             a.scanner_address,
             a.process_wait_time
      INTO   lvs_dio_port,
             lvs_scanner_port,
             lvs_equipment_port,
             lvs_dio_address,
             lvs_bcr_code,
             lvs_buffer_type,
             lvs_workstage_code,
             lvs_workstage_name,
             lvf_process_process_time,
             lvs_scanner_address,
             lvs_process_wait_time
      FROM   imcn_machine a, ip_product_workstage b
     WHERE   a.line_code = p_line_code
         AND a.machine_code = p_machine_code
         AND a.workstage_code = b.workstage_code(+)
         AND a.organization_id = b.organization_id(+);

    -------------------------------------------------------------------
    --
    -------------------------------------------------------------------

    IF p_config = 'DIO_PORT'
    THEN
        p_out := lvs_dio_port;
    ELSIF p_config = 'SCANNER_PORT'
    THEN
        p_out := lvs_scanner_port;
    ELSIF p_config = 'EQUIPMENT_PORT'
    THEN
        p_out := lvs_equipment_port;
    ELSIF p_config = 'DIO_ADDRESS'
    THEN
        p_out := lvs_dio_address;
    ELSIF p_config = 'BCR_CODE'
    THEN
        p_out := lvs_bcr_code;
    ELSIF p_config = 'BUFFER_TYPE'
    THEN
        p_out := lvs_buffer_type;
    ELSIF p_config = 'WORKSTAGE_CODE'
    THEN
        p_out := lvs_workstage_code;
    ELSIF p_config = 'WORKSTAGE_NAME'
    THEN
        p_out := lvs_workstage_name;
    ELSIF p_config = 'SCANNER_ADDRESS'
    THEN
        p_out := lvs_scanner_address;
    ELSIF p_config = 'PROCESS_WAIT_TIME'
    THEN
        p_out := lvs_process_wait_time;
    END IF;

--    -------------------------------------------------------------------------
--    --
--    ------------------------------------------------------------------------
--    INSERT INTO iq_interlock_request_log (line_code,
--                                          machine_code,
--                                          serial_no,
--                                          request_date,
--                                          comments,
--                                          log_sequence,
--                                          workstage_code,
--                                          interlock_type,
--                                          return_value)
--      VALUES   (p_line_code,
--                p_machine_code,
--                '*',
--                SYSDATE,
--                'LINE CONFIG',
--                seq_interlock_log.NEXTVAL,
--                '*',
--                p_config,
--                p_out);
--
--    COMMIT;
    RETURN;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        p_out := 'NO DATA FOUND';

--        -------------------------------------------------------------------------
--        --
--        ------------------------------------------------------------------------
--        INSERT INTO iq_interlock_request_log (line_code,
--                                              machine_code,
--                                              serial_no,
--                                              request_date,
--                                              comments,
--                                              log_sequence,
--                                              workstage_code,
--                                              interlock_type,
--                                              return_value)
--          VALUES   (p_line_code,
--                    p_machine_code,
--                    '*',
--                    SYSDATE,
--                    'LINE CONFIG',
--                    seq_interlock_log.NEXTVAL,
--                    '*',
--                    p_config,
--                    p_out);
--
--        COMMIT;
        RETURN;
    WHEN OTHERS
    THEN
        p_out :=SQLERRM ;
        raise_application_error (-20003, SQLERRM);
END;