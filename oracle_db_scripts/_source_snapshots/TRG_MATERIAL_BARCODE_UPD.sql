TRIGGER "INFINITY21_JSMES"."TRG_MATERIAL_BARCODE_UPD" 
 AFTER
   UPDATE OF barcode_status
 ON im_item_inventory_barcode
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE

   phase                       NUMBER       := 0;


   
BEGIN
--   phase := '10';
   
   IF :NEW.BARCODE_STATUS = '2'
   THEN
phase := '10';
    END IF;
     
     EXCEPTION
          WHEN OTHERS
          THEN
          RAISE_APPLICATION_ERROR(-20003 , SQLERRM);
     END ;