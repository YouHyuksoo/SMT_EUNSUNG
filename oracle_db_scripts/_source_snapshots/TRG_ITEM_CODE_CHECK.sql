TRIGGER "INFINITY21_JSMES"."TRG_ITEM_CODE_CHECK" 
 BEFORE
  INSERT
 ON id_eng_bom
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   numrows   INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO numrows
     FROM id_item
    WHERE item_code = :NEW.parent_item_code
      AND organization_id = :NEW.organization_id;

   IF numrows = 0
   THEN
      raise_application_error (
         -20003,
            :NEW.parent_item_code
         || ' Parent Item Not Found in Item Master'
      );
   END IF;

   numrows := 0;
   SELECT COUNT (*)
     INTO numrows
     FROM id_item
    WHERE item_code = :NEW.child_item_code
      AND organization_id = :NEW.organization_id;

   IF numrows = 0
   THEN
      raise_application_error (
         -20003,
            NVL(:NEW.child_item_code , 'null')
         || ' Child Item Not Found in Item Master'
      );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error (-20003, 'Item Not Found in Item Master');
END;