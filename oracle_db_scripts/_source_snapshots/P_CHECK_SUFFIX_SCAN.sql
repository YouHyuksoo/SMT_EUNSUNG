PROCEDURE "P_CHECK_SUFFIX_SCAN" (p_line_code    IN     VARCHAR2,
/* Formatted on 2015-05-18 10:02:25 (QP5 v5.126) */
                               p_model_name   IN     VARCHAR2,
                               p_barcode      IN     VARCHAR2,
                               p_deficit      IN     VARCHAR2,
                               p_out             OUT VARCHAR2)
IS
    lvi_count           NUMBER;
    lvi_suffix_count    NUMBER;
    lvs_item_code       VARCHAR2 (20);
    lvs_location_code   VARCHAR2 (20);
BEGIN
    IF p_deficit = 'N'
    THEN
        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_count
              FROM   ib_product_plandata
             WHERE   line_code = SUBSTR (p_line_code, 1, 2)
                 AND model_name = p_model_name
                 AND active_yn = 'Y'
                 AND organization_id = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                p_out := p_line_code || '  ' || p_model_name || f_msg(' NOT FOUND','C',1);
                RETURN;
        END;

        ---------------------------------------------------------------------
        --
        ---------------------------------------------------------------------
        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_suffix_count
              FROM   id_item
             WHERE   model_name = p_model_name AND model_suffix = p_barcode AND organization_id = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lvi_suffix_count := 0;
        END;

        p_out := p_line_code || '  ' || p_model_name || ' ' || p_barcode || f_msg(' NOT FOUND','C',1);
        RETURN;

        -------------------------------------------------------------------
        -- NO REPLACE ITEM CHECK
        -------------------------------------------------------------------
        BEGIN
            SELECT   MAX (item_code), MAX (location_code), COUNT ( * )
              INTO   lvs_item_code, lvs_location_code, lvi_count
              FROM   ib_product_plandata
             WHERE   item_code IN
                             (SELECT   replace_item_code
                                FROM   id_eng_bom_smt_no_replace
                               WHERE   line_code = SUBSTR (p_line_code, 1, 2)
                                   AND model_name = p_model_name
                                   AND model_suffix = p_barcode);
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lvi_count := 0;
        END;

        IF lvi_count > 0
        THEN
            p_out := 'NG ' || lvs_item_code || ' ' || lvs_location_code || f_msg(' NO REPLACE ITEM EXISTS','C',1);
            RETURN;
        END IF;

        -------------------------------------------------------------------
        -- update
        -------------------------------------------------------------------

        UPDATE   ib_product_plandata
           SET   model_suffix = p_barcode
         WHERE   line_code = SUBSTR (p_line_code, 1, 2)
             AND model_name = p_model_name
             AND active_yn = 'Y'
             AND organization_id = 1;
    -------------------------------------------------------------------
    -- CANCEL
    -------------------------------------------------------------------
    ELSE
        UPDATE   ib_product_plandata
           SET   model_suffix = NULL
         WHERE   line_code = SUBSTR (p_line_code, 1, 2)
             AND model_name = p_model_name
             AND active_yn = 'Y'
             AND organization_id = 1;
    END IF;

    COMMIT;
    p_out := 'OK';
    RETURN;
EXCEPTION
    WHEN OTHERS
    THEN
        p_out := 'NG';
        RETURN;
END;