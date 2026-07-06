TRIGGER "INFINITY21_JSMES"."TRG_IP_PROD_RUN_MODEL_LOG_UPD" 
  before update on IP_PRODUCT_RUN_MODEL
  for each row
declare
  -- local variables here
begin

          -- Interlock condition update？？？？？？？？？

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
        SELECT :OLD.ORGANIZATION_ID,
               :OLD.LINE_CODE,
               :OLD.WORKSTAGE_CODE,
               :OLD.MODEL_NAME,
               :OLD.ITEM_CODE,
               :OLD.PCB_ITEM,
               :OLD.RUN_NO,
               :OLD.ENTER_DATE,
               :OLD.ENTER_BY,
               :OLD.LAST_MODIFY_DATE,
               :OLD.LAST_MODIFY_BY,
               :OLD.AOI_MASTER_SAMPLE_CHECK,
               :OLD.AOI_MASTER_SAMPLE_PID,
               :OLD.AOI_MASTER_SAMPLE_DATE,
               SYS_CONTEXT('USERENV','TERMINAL'),     -- terminal ,
               SYS_CONTEXT('USERENV','CURRENT_USER'), -- current_user,
               SYS_CONTEXT('USERENV','HOST'),         -- host,
               SYS_CONTEXT('USERENV','IP_ADDRESS'),   -- ip_address,
               'UPDATE',
               SYSDATE,
               :OLD.CHILD_ITEM_CODE
          FROM DUAL;

  EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);

end;