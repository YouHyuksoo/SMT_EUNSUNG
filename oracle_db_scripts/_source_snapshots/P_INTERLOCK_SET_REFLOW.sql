PROCEDURE "P_INTERLOCK_SET_REFLOW" (p_line_code     IN     VARCHAR2,
                                  p_file_name     IN     VARCHAR2,
                                  p_check_date    IN     VARCHAR2,
                                  p_zone_no       IN     VARCHAR2,
                                  p_set_temp      IN     VARCHAR2,
                                  p_check_temp    IN     VARCHAR2,
                                  p_air_density   IN     VARCHAR2,
                                  p_air_n2_type   IN     VARCHAR2,
                                  p_solder_type   IN     VARCHAR2,  --FILE NAME PREFIX 2 DIGIT
                                  p_result        IN     VARCHAR2,
                                  p_out              OUT VARCHAR2)
IS
    r_count   INTEGER := 0;
BEGIN
    BEGIN
        SELECT   COUNT (1)
          INTO   r_count
          FROM   iq_interlock_reflow_status
         WHERE   line_code = p_line_code;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            r_count := 0;
    END;

    IF r_count > 0
    THEN
        UPDATE   iq_interlock_reflow_status
           SET   file_name = p_file_name,
                 check_date = SYSDATE,
                 zone_no = zone_no,
                 set_temp = p_set_temp,
                 check_temp = p_check_temp,
                 reflow_result = p_result,
                 air_density = p_air_density,
                 air_n2_type = p_air_n2_type,
                 solder_type = p_solder_type,
                 comments = p_check_date,
                 organization_id = 1
         WHERE   line_code = p_line_code;
    ELSE
        INSERT INTO iq_interlock_reflow_status (line_code,
                                                file_name,
                                                check_date,
                                                zone_no,
                                                set_temp,
                                                check_temp,
                                                air_density,
                                                air_n2_type,
                                                solder_type,
                                                reflow_result,
                                                comments,
                                                organization_id)
          VALUES   (p_line_code,
                    p_file_name,
                    SYSDATE,
                    p_zone_no,
                    p_set_temp,
                    p_check_temp,
                    p_air_density,
                    p_air_n2_type,
                    p_solder_type,
                    p_result,
                    p_check_date,
                    1);
    END IF;

    p_out := 'OK';

    COMMIT;
    RETURN;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;