PROCEDURE "P_INTERLOCK_LOT_INFO" (p_run_no IN VARCHAR2, p_type IN VARCHAR2, p_out OUT VARCHAR2)
/* Formatted on 2015-07-12 15:49:56 (QP5 v5.126) */
IS
    -- ---------   ------  -------------------------------------------
    lvs_model_name         VARCHAR2 (30);
    lvs_parent_item_code   VARCHAR2 (30);
    lvl_lot_size           NUMBER;
    lvs_array_type         VARCHAR2 (10);
    lvl_good_count         INT;
------------------------------------------------------------------

-- CARRIER_SIZE

BEGIN
    SELECT   model_name, parent_item_code, lot_size
      INTO   lvs_model_name, lvs_parent_item_code, lvl_lot_size
      FROM   ip_product_run_card
     WHERE   run_no = p_run_no;

    BEGIN
        SELECT   MAX (array_type)
          INTO   lvs_array_type
          FROM   ip_product_model_master
         WHERE   item_code = lvs_parent_item_code;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            raise_application_error (-20003, 'ARRAY TYPE ERROR ' || SQLERRM);
    END;

    --------------------------------------------------------------------------
    --
    --------------------------------------------------------------------------

    IF p_type = 'MODEL_NAME'
    THEN
        p_out := lvs_model_name;
    ELSIF p_type = 'ITEM_CODE'
    THEN
        p_out := lvs_parent_item_code;
    ELSIF p_type = 'LOT_SIZE'
    THEN
        p_out := lvl_lot_size;
    ELSIF p_type = 'ARRAY_TYPE'
    THEN
        p_out := lvs_array_type;
    ELSIF p_type = 'GOOD_COUNT'
    THEN
        SELECT   COUNT (1)
          INTO   lvl_good_count
          FROM   ip_product_2d_barcode
         WHERE   run_no = p_run_no;

        p_out := lvl_good_count;
    ELSE
        p_out := '*';
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
--      VALUES   ('*',
--                '*',
--                p_run_no,
--                SYSDATE,
--                'LOT INFOR',
--                seq_interlock_log.NEXTVAL,
--                '*',
--                p_type,
--                p_out);
--
--    COMMIT;

    --------------------------------------------------------------------------
    --
    --------------------------------------------------------------------------

    RETURN;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        p_out := 'NOT FOUND RUNCARD';

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
--          VALUES   ('*',
--                    '*',
--                    p_run_no,
--                    SYSDATE,
--                    'LOT INFOR',
--                    seq_interlock_log.NEXTVAL,
--                    '*',
--                    p_type,
--                    p_out);
--
--        COMMIT;

        RETURN;
    WHEN OTHERS
    THEN
      p_out :=SQLERRM ;
        raise_application_error (-20003, SQLERRM);
END;