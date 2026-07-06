TRIGGER "INFINITY21_JSMES"."TRG_MCN_MOLD_ISSUE_INS" 
 BEFORE
  INSERT
 ON imcn_mold_issue
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt                     NUMBER       := 0;
   lvs_currency                VARCHAR2 (3);
   lvs_local_currency          VARCHAR2 (3);
   lvf_exchange_rate           NUMBER       := 0;
   lvf_unit_price              NUMBER       := 0;
   lvs_delivery                VARCHAR (10);
   lvi_count                   NUMBER       := 0;
   lvf_last_dd_avg_price       NUMBER       := 0;
   lvf_last_dd_inventory_qty   NUMBER       := 0;
   lvf_last_dd_inventory_amt   NUMBER       := 0;
   lvf_mm_issue_qty            NUMBER       := 0;
   lvf_mm_issue_amt            NUMBER       := 0;
   lvf_mm_receipt_qty          NUMBER       := 0;
   lvf_mm_receipt_amt          NUMBER       := 0;
   phase                       NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM imcn_mold_inventory
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      raise_application_error (-20003,
                                  'Mold Code Not Found in Mold Mastert '
                               || SQLERRM
                              );
   ELSE
      UPDATE imcn_mold_inventory
         SET inventory_qty = NVL (inventory_qty, 0) - :NEW.issue_qty,
             inventory_amt =
                            inventory_amt
                            - (:NEW.issue_qty * inventory_price),
             mold_in_out = DECODE (:NEW.issue_deficit, '3', 'O', 'I'),
             last_issue_date =
                    DECODE (:NEW.issue_deficit,
                            '3', SYSDATE,
                            last_issue_date
                           ),
             last_receipt_date =
                  DECODE (:NEW.issue_deficit,
                          '4', SYSDATE,
                          last_receipt_date
                         ),
             machine_code =
                      DECODE (:NEW.issue_deficit,
                              '3', :NEW.machine_code,
                              NULL
                             ),
             workstage_code =
                    DECODE (:NEW.issue_deficit,
                            '3', :NEW.workstage_code,
                            NULL
                           ),
             line_code = DECODE (:NEW.issue_deficit,
                                 '3', :NEW.line_code,
                                 NULL
                                ),
             mold_use_status = DECODE (:NEW.issue_deficit , '3' , DECODE(:NEW.MOLD_ISSUE_ACCOUNT , 'M010' ,'R','P'),'U') ,--R REPAIR , P PRODUCT
             location_code   = :new.location_code
       WHERE mold_code       = :NEW.mold_code
         AND mold_version    = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id;

-------------------------------------------------------
-- MACHINE CURRENT MOLD SETUP
-------------------------------------------------------
      IF :NEW.mold_issue_account = 'M001'
      THEN
         UPDATE imcn_machine
            SET mold_code =
                         DECODE (:NEW.issue_deficit,
                                 '3', :NEW.mold_code,
                                 NULL
                                ),
                mold_version =
                      DECODE (:NEW.issue_deficit,
                              '3', :NEW.mold_version,
                              NULL
                             ),
                mold_set_serial =
                   DECODE (:NEW.issue_deficit,
                           '3', :NEW.mold_set_serial,
                           NULL
                          ),
                mold_exists_yn = DECODE (:NEW.issue_deficit, '3', 'Y', 'N')
          WHERE machine_code = :NEW.machine_code
            AND organization_id = :NEW.organization_id;
      END IF;
   END IF;

-------------------------------------------------
-- MOLD LOATION UPDATE
-------------------------------------------------
   IF :NEW.issue_deficit = '3'
   THEN                                                               -- issue
      UPDATE imcn_mold_location
         SET
             --mold_code = null,
             --mold_version = null,
             --mold_set_serial = null,
             mold_location_status = 'O'
       WHERE mold_location_code = :NEW.location_code
         AND organization_id = :NEW.organization_id;
   ELSE
      UPDATE imcn_mold_location
         SET mold_code = :NEW.mold_code,
             mold_version = :NEW.mold_version,
             mold_set_serial = :NEW.mold_set_serial,
             mold_location_status = 'I'
       WHERE mold_location_code = :NEW.location_code
         AND organization_id = :NEW.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;