TRIGGER "INFINITY21_JSMES"."AUDIT_IM_ITEM_ARRIVAL_30030" 
 BEFORE
  INSERT
 ON im_item_arrival
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 WHEN (
NEW.arrival_status = 'A'
      ) BEGIN
   IF NVL (:NEW.arrival_status, 'N') = 'N'
   THEN
      INSERT INTO "ISYS_AUDIT_MESSAGE"
                  (audit_message_id,
                   audit_date,
                   organization_id,
                   msg_id,
                   confirm_yn,
                   confirm_by,
                   confirm_date,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (seq_audit_msg_sequence.NEXTVAL,
                   TRUNC (SYSDATE),
                   :NEW.organization_id,
                   30030, --'ITEM ARRIVAL'
                   'N',
                   NULL,
                   NULL,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   ELSIF :NEW.arrival_status = 'C'
   THEN
      INSERT INTO "ISYS_AUDIT_MESSAGE"
                  (audit_message_id,
                   audit_date,
                   organization_id,
                   msg_id,
                   confirm_yn,
                   confirm_by,
                   confirm_date,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (seq_audit_msg_sequence.NEXTVAL,
                   TRUNC (SYSDATE),
                   :NEW.organization_id,
                   40030, --'ITEM ARRIVAL CANCELED'
                   'N',
                   NULL,
                   NULL,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   END IF;
END;