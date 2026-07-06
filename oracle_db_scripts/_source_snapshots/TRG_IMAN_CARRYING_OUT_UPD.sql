TRIGGER "INFINITY21_JSMES"."TRG_IMAN_CARRYING_OUT_UPD" 
 BEFORE
   UPDATE OF confirm_yn
 ON iman_carrying_out
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 WHEN (
new.confirm_yn = 'Y'
      ) DECLARE
   lvi_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO lvi_count
     FROM isys_audit_message
    WHERE carrying_out_group_no = :OLD.carrying_out_group_no
      and confirm_yn = 'N'
      and organization_id = :OLD.organization_id;

   IF lvi_count < 0
   
   THEN
      NULL;
   ELSE
       INSERT INTO "ISYS_AUDIT_MESSAGE_HISTORY"  
         ( AUDIT_MESSAGE_ID,   
           AUDIT_DATE,   
           ORGANIZATION_ID,   
           MSG_ID,   
           CONFIRM_YN,   
           CONFIRM_BY,   
           CONFIRM_DATE,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY )  
     SELECT seq_audit_msg_sequence.NEXTVAL,-- :NEW.AUDIT_MESSAGE_ID,   
           SYSDATE ,  --:NEW.AUDIT_DATE,   
           :NEW.ORGANIZATION_ID,   
           30200 , --MSG_ID,   
           'Y' , --CONFIRM_YN,   
           :NEW.ENTER_BY , --CONFIRM_BY,   
           SYSDATE , --CONFIRM_DATE,   
           SYSDATE , --ENTER_DATE,   
           ENTER_BY,   
           :NEW.LAST_MODIFY_DATE,   
           :NEW.LAST_MODIFY_BY 
       FROM ISYS_AUDIT_MESSAGE  
       WHERE carrying_out_group_no = :OLD.carrying_out_group_no
         and organization_id = :OLD.organization_id;
   END IF;
   
    delete from  ISYS_AUDIT_MESSAGE
    WHERE carrying_out_group_no = :OLD.carrying_out_group_no
      and organization_id = :OLD.organization_id;
      
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;