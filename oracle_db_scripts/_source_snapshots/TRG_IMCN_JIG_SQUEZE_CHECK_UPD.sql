TRIGGER "INFINITY21_JSMES"."TRG_IMCN_JIG_SQUEZE_CHECK_UPD"
 BEFORE UPDATE ON IMCN_JIG_SQUEZE_CHECK
 FOR EACH ROW
DECLARE

BEGIN
   
   IF (:NEW.CLEAN_YN = 'N' OR :NEW.PIN_HOLE_YN = 'N' OR :NEW.JIG_CHECK_STATUS = 'N') THEN
     
       update imcn_jig
          set use_status      = 'S' 
        where jig_lot_no      = :NEW.jig_lot_no
          and jig_type        = 'S' 
          and organization_id = 1 ; 
          
   ELSE
           
       update imcn_jig
          set use_status      = 'U' 
        where jig_lot_no      = :NEW.jig_lot_no
          and jig_type        = 'S' 
          and organization_id = 1 ; 
          
   END IF;
   
EXCEPTION
    WHEN OTHERS THEN
         raise_application_error (-20003, SQLERRM);

END;
