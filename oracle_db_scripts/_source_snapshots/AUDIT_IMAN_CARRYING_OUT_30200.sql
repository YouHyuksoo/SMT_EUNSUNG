TRIGGER "INFINITY21_JSMES"."AUDIT_IMAN_CARRYING_OUT_30200" 
 BEFORE
   UPDATE OF request_status
 ON iman_carrying_out
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
   IF NVL (:OLD.request_status, 'W') = NVL (:NEW.request_status, 'W')
   THEN
      NULL;
   ELSE
      IF NVL (:NEW.request_status, 'W') = 'R'
      THEN
         BEGIN
            SELECT COUNT (*)
              INTO lvi_count
              FROM isys_audit_message
             WHERE msg_id = 30200
               AND organization_id = :NEW.organization_id
               AND carrying_out_group_no = :NEW.carrying_out_group_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               lvi_count := 0;
         END;

         IF lvi_count > 0
         THEN
            NULL;
         ELSE
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
                         last_modify_by,
                         carrying_out_group_no
                        )
                 VALUES (seq_audit_msg_sequence.NEXTVAL,
                         TRUNC (SYSDATE),
                         :NEW.organization_id,
                         30200, --'CARING OUT'
                         'N',
                         NULL,
                         NULL,
                         SYSDATE,
                         :NEW.enter_by,
                         SYSDATE,
                         :NEW.last_modify_by,
                         :NEW.carrying_out_group_no
                        );
         END IF;
      END IF;
   END IF;
END;