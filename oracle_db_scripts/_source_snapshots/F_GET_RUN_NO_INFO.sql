FUNCTION "F_GET_RUN_NO_INFO" (p_pid    IN VARCHAR2,
                                              p_option IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return      VARCHAR2 (100);

    lvs_run_no      VARCHAR2 (100);
    lvs_comments    VARCHAR2 (100);
    lvs_marking_no  VARCHAR2 (100);
    lvs_lot_size    VARCHAR2 (100);

BEGIN

    BEGIN

        SELECT run_no,      -- run_no
               comments,    -- model.suffix,
               marking_no,   -- w/o
               lot_size     -- lot_qty
          INTO lvs_run_no,
               lvs_comments,
               lvs_marking_no,
               lvs_lot_size
          FROM ip_product_run_card
         WHERE run_no = (
                          select run_no
                            from ip_product_2d_barcode
                           where serial_no       = p_pid
                             and organization_id = 1
                        )
           AND organization_id = 1;

    EXCEPTION

        WHEN NO_DATA_FOUND THEN
             lvs_run_no      := '';
             lvs_comments    := '';
             lvs_marking_no  := '';
             lvs_lot_size    := '0';

    END;

    CASE p_option
         WHEN 'RUN NO'  THEN
              lvs_return := lvs_run_no;
         WHEN 'MODEL'   THEN
              lvs_return := lvs_comments;
         WHEN 'WO'      THEN
              lvs_return := lvs_marking_no;
         WHEN 'LOT SIZE' THEN
              lvs_return := lvs_lot_size;
         ELSE
              lvs_return := 'ERROR';
    END CASE;

    RETURN lvs_return;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR';

END;