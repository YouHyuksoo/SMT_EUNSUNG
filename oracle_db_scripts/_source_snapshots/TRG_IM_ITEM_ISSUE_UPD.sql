TRIGGER "TRG_IM_ITEM_ISSUE_UPD"
 BEFORE
   UPDATE OF issue_status
 ON im_item_issue
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
  
   NULL;
   
  
/*  

 IF :NEW.issue_status = 'C' THEN
     
      UPDATE im_item_workstage_receipt
         SET receipt_status = 'C'
       WHERE issue_date = :OLD.issue_date
         AND issue_sequence = :OLD.issue_sequence
         AND receipt_status = 'N'
         AND organization_id = :OLD.organization_id;
         
   END IF;
   
*/
   
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
