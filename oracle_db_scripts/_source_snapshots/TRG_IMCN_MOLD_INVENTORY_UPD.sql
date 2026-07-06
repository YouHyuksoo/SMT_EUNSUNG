TRIGGER "INFINITY21_JSMES"."TRG_IMCN_MOLD_INVENTORY_UPD" 
 BEFORE
   UPDATE OF actual_value, location_code, last_adjust_date
 ON imcn_mold_inventory
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   IF :OLD.location_code <> :NEW.location_code
   THEN
      UPDATE imcn_mold_location
         SET mold_code = NULL,
             mold_version = NULL,
             mold_set_serial = NULL,
             mold_location_status = 'O'
       WHERE mold_location_code = :OLD.location_code
         AND organization_id = :OLD.organization_id;

      UPDATE imcn_mold_location
         SET mold_code = :OLD.mold_code,
             mold_version = :OLD.mold_version,
             mold_set_serial = :OLD.mold_set_serial,
             mold_location_status = 'I'
       WHERE mold_location_code = :NEW.location_code
         AND organization_id = :OLD.organization_id;
   END IF;

   -- ONLY MASK
   IF NVL (:OLD.last_adjust_date, SYSDATE) <> :NEW.last_adjust_date
   THEN
      INSERT INTO imcn_mold_repair
                  (mold_code,
                   repair_sequence,
                   organization_id,
                   repair_request_date,
                   repair_reason_code,
                   repair_vendor_code,
                   repair_status,
                   repair_by,
                   repair_date,
                   repair_qty,
                   repair_amt,
                   currency,
                   comments,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   mold_version,
                   mold_set_serial,
                   repair_time,
                   repair_comments
                  )
           VALUES (:NEW.mold_code,
                   seq_mold_repair_sequence.NEXTVAL,       -- REPAIR_SEQUENCE,
                   :NEW.organization_id,
                   :NEW.last_adjust_date,              -- REPAIR_REQUEST_DATE,
                   'MJ31',                      --REPAIR_REASON_CODE, --ADJUST
                   '*',                                  --REPAIR_VENDOR_CODE,
                   'C',                            --REPAIR_STATUS, --COMPLETE
                   :NEW.last_modify_by,                          -- REPAIR_BY,
                   :NEW.last_adjust_date,                      -- REPAIR_DATE,
                   1,                                            --REPAIR_QTY,
                   0,                                            --REPAIR_AMT,
                   'CNY',                                         -- CURRENCY,
                   '',                                            -- COMMENTS,
                   :NEW.enter_by,
                   SYSDATE,                                     -- ENTER_DATE,
                   :NEW.last_modify_by,
                   SYSDATE,                                --LAST_MODIFY_DATE,
                   :NEW.mold_version,
                   :NEW.mold_set_serial,
                   0,                                           --REPAIR_TIME,
                   ''                                        --REPAIR_COMMENTS
                  );
   END IF;

   IF :NEW.actual_value IS NULL OR :NEW.actual_value = 0
   THEN
      NULL;
   ELSE
      INSERT INTO imcn_mold_short_history
                  (mold_code,
                   product_date,
                   short_qty,
                   organization_id,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   mold_version,
                   mold_set_serial,
                   product_type,
                   delete_protect_yn
                  )
           VALUES (:NEW.mold_code,
                   TRUNC (SYSDATE),                            --PRODUCT_DATE,
                   :NEW.actual_value - NVL (:OLD.actual_value, 0),
                                                                  --SHORT_QTY,
                   :NEW.organization_id,
                   :NEW.enter_by,                                  --ENTER_BY,
                   SYSDATE,                                      --ENTER_DATE,
                   :NEW.last_modify_by,                      --LAST_MODIFY_BY,
                   SYSDATE,                                --LAST_MODIFY_DATE,
                   :NEW.mold_version,
                   :NEW.mold_set_serial,
                   'M',                                        --PRODUCT_TYPE,
                   'Y'                                     --DELETE_PROTECT_YN
                  );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;