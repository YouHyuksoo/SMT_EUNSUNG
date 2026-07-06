TRIGGER "INFINITY21_JSMES"."TRG_IP_PROD_RUN_MODEL_LOG_INS" 
  before insert on IP_PRODUCT_RUN_MODEL
  for each row
declare
  -- local variables here
begin

          -- Interlock condition insert？？？？？？？？？

         INSERT INTO IP_PRODUCT_RUN_MODEL_LOG (
                                                ORGANIZATION_ID,
                                                LINE_CODE,
                                                WORKSTAGE_CODE,
                                                MODEL_NAME,
                                                ITEM_CODE,
                                                PCB_ITEM,
                                                RUN_NO,
                                                ENTER_DATE,
                                                ENTER_BY,
                                                LAST_MODIFY_DATE,
                                                LAST_MODIFY_BY,
                                                AOI_MASTER_SAMPLE_CHECK,
                                                AOI_MASTER_SAMPLE_PID,
                                                AOI_MASTER_SAMPLE_DATE,
                                                TERMINAL,
                                                CURRENT_USER,
                                                HOST,
                                                IP_ADDRESS,
                                                TRIGGER_MODE,
                                                TRIGGER_DATE,
                                                CHILD_ITEM_CODE
                                               )
        SELECT :NEW.ORGANIZATION_ID,
               :NEW.LINE_CODE,
               :NEW.WORKSTAGE_CODE,
               :NEW.MODEL_NAME,
               :NEW.ITEM_CODE,
               :NEW.PCB_ITEM,
               :NEW.RUN_NO,
               :NEW.ENTER_DATE,
               :NEW.ENTER_BY,
               :NEW.LAST_MODIFY_DATE,
               :NEW.LAST_MODIFY_BY,
               :NEW.AOI_MASTER_SAMPLE_CHECK,
               :NEW.AOI_MASTER_SAMPLE_PID,
               :NEW.AOI_MASTER_SAMPLE_DATE,
               SYS_CONTEXT('USERENV','TERMINAL'),     -- terminal ,
               SYS_CONTEXT('USERENV','CURRENT_USER'), -- current_user,
               SYS_CONTEXT('USERENV','HOST'),         -- host,
               SYS_CONTEXT('USERENV','IP_ADDRESS'),   -- ip_address,
               'INSERT',
               SYSDATE,
               :NEW.CHILD_ITEM_CODE
          FROM DUAL;

  EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);

end;