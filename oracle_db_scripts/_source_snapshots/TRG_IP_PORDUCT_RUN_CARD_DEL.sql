TRIGGER "INFINITY21_JSMES"."TRG_IP_PORDUCT_RUN_CARD_DEL" 
 BEFORE
 DELETE
 ON IP_PRODUCT_RUN_CARD
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN

    DELETE FROM   ip_product_run_card_detail
          WHERE   run_no = :old.run_no
                  AND organization_id = :old.organization_id;

    UPDATE   ip_product_smd_plan
       SET   plan_status = 'W' --WAIT
     WHERE   mfs = :old.lot_no 
       AND organization_id = :old.organization_id;
END;