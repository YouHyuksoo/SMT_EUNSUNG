TRIGGER "INFINITY21_JSMES"."TRG_MAT_ITEM_WS_ISSUE_INS" 
 BEFORE
  INSERT
 ON im_item_workstage_issue
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt   NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM im_item_workstage_inventory
       WHERE item_code = :NEW.item_code
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      INSERT INTO im_item_workstage_inventory
                  (
                   item_code,
                
                   organization_id,
               
                   inventory_qty,
             
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (
                   :NEW.item_code,
      
                   :NEW.organization_id,
               
                   :NEW.issue_qty * -1,
              
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   ELSE
      BEGIN
         SELECT COUNT (*)
           INTO lvl_cnt
           FROM im_item_workstage_inventory
          WHERE item_code = :NEW.item_code
            AND organization_id = :NEW.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  :NEW.item_code
            
            );
      END;

      IF lvl_cnt = 0
      THEN
         raise_application_error (
            -20003,
               :NEW.item_code
           
         );
      END IF;

      UPDATE im_item_workstage_inventory
         SET inventory_qty =   NVL (inventory_qty, 0) - NVL (:NEW.issue_qty, 0) ,
              last_modify_by = 'WORKSTAGE ISSUE' ,
              last_modify_date = sysdate
                             
       WHERE item_code = :NEW.item_code
         AND organization_id = :NEW.organization_id;

   END IF;
-------------------------------------------------------------
--
-------------------------------------------------------------
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;