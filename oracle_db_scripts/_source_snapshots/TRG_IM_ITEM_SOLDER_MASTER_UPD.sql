TRIGGER "TRG_IM_ITEM_SOLDER_MASTER_UPD"
 BEFORE
   UPDATE OF RECEIPT_DATE, ISSUE_DATE, DESTROY_DATE, VALID_DATE  ON IM_ITEM_SOLDER_MASTER
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN

  
       INSERT INTO IM_ITEM_SOLDER_MASTER_HIS (
                                             item_barcode,
                                             
                                             OLD_RECEIPT_DATE           ,
                                             OLD_ISSUE_DATE             , 
                                             OLD_INPUT_DATE             ,
                                             OLD_DESTROY_DATE           ,  
  
                                             OLD_VISCOSITY_START_DATE   , 
                                             OLD_VISCOSITY_END_DATE     ,  
                                             OLD_VALID_DATE             ,    
               
                                             NEW_RECEIPT_DATE           ,
                                             NEW_ISSUE_DATE             , 
                                             NEW_INPUT_DATE             ,
                                             NEW_DESTROY_DATE           ,  
  
                                             NEW_VISCOSITY_START_DATE   , 
                                             NEW_VISCOSITY_END_DATE     ,  
                                             NEW_VALID_DATE             ,
                                             
                                             enter_date                 ,
                                             enter_by                   ,   
                                             last_modify_date           ,     
                                             last_modify_by             ,
                                             organization_id                   
                                         )
                                 SELECT :NEW.item_barcode           ,
                                 
                                        :OLD.RECEIPT_DATE           ,
                                        :OLD.ISSUE_DATE             , 
                                        :OLD.INPUT_DATE             ,
                                        :OLD.DESTROY_DATE           , 
               
                                        :OLD.VISCOSITY_START_DATE   , 
                                        :OLD.VISCOSITY_END_DATE     ,  
                                        :OLD.VALID_DATE             ,    
               
                                        :NEW.RECEIPT_DATE           ,
                                        :NEW.ISSUE_DATE             , 
                                        :NEW.INPUT_DATE             ,
                                        :NEW.DESTROY_DATE           ,  
               
                                        :NEW.VISCOSITY_START_DATE   , 
                                        :NEW.VISCOSITY_END_DATE     ,  
                                        :NEW.VALID_DATE             ,

                                        sysdate                     ,
                                        'UPD TRIGGER'               ,
						                            sysdate                     ,
                                        'UPD TRIGGER'               ,
						                            1
                                   FROM DUAL;					



EXCEPTION
   WHEN OTHERS THEN
        raise_application_error (-20003, SQLERRM);
END;
