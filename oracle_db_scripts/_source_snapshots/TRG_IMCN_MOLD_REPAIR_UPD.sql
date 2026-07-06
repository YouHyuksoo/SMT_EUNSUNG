TRIGGER "INFINITY21_JSMES"."TRG_IMCN_MOLD_REPAIR_UPD" 
 BEFORE
   UPDATE OF repair_status
 ON imcn_mold_repair
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   IF :NEW.repair_status = 'C' --complete
   -- OR :NEW.repair_status = 'P'
   THEN
      UPDATE imcn_mold_inventory
         SET mold_use_status = 'U',
             mold_in_out = 'I',
             repair_vendor_code = '',
             last_receipt_date = SYSDATE
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id;
   ELSIF :NEW.repair_status = 'P' THEN
      UPDATE imcn_mold_inventory
         SET mold_use_status = 'R',
             mold_in_out = 'O', --OUT STATUS
             repair_vendor_code = :NEW.repair_vendor_code,
             last_issue_date = SYSDATE
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;