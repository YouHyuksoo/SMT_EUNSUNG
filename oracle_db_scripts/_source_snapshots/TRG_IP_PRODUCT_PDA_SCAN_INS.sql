TRIGGER "INFINITY21_JSMES"."TRG_IP_PRODUCT_PDA_SCAN_INS" 
 AFTER
  INSERT
 ON ip_product_pda_scan_master
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvi_count   NUMBER;
BEGIN
    IF :new.material_mfs IS NULL
    THEN
        NULL;
    ELSE
        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_count
              FROM   ip_product_run_card
             WHERE       run_date >= TRUNC (SYSDATE) - 3
                     AND run_no = :new.run_no
                     AND active_yn = 'Y'
                     AND line_code = :new.line_code;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lvi_count := 0;
        END;


        IF lvi_count = 0
        THEN
            UPDATE   ip_product_run_card
               SET   active_yn = 'N'
                  --active_date = SYSDATE
             WHERE       run_date >= TRUNC (SYSDATE) - 3
                     --   AND run_no <> :new.run_no
                     AND NVL (active_yn, 'N') = 'L'
                     AND line_code = :new.line_code;

            UPDATE   ip_product_run_card
               SET   active_yn = 'L' --, active_date = SYSDATE
             WHERE       run_date >= TRUNC (SYSDATE) - 3
                     AND run_no <> :new.run_no
                     AND NVL (active_yn, 'N') = 'Y'
                     AND line_code = :new.line_code;

            UPDATE   ip_product_run_card
               SET   run_status = '4', active_yn = 'Y' --, active_date = SYSDATE
             WHERE   run_no = :new.run_no AND line_code = :new.line_code;



          --  UPDATE   ip_product_pcb_scan_master
              -- SET   pda_scan_date = SYSDATE
         --    WHERE   run_no = :new.run_no AND pda_scan_date IS NULL;

            COMMIT;
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        NULL;
    WHEN OTHERS
    THEN
        NULL;
END;