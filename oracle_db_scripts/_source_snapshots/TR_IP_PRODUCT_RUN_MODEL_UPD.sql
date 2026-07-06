TRIGGER "INFINITY21_JSMES"."TR_IP_PRODUCT_RUN_MODEL_UPD" 
 AFTER UPDATE ON IP_PRODUCT_RUN_MODEL   FOR EACH ROW
DECLARE

BEGIN

  IF LENGTH(NVL(:NEW.AOI_MASTER_SAMPLE_PID,'')) > 1 THEN
  -----------------------------------------------------------------
  -- 2016/08/30 SHS, Master sample ？？？？？？ ？？？？

  -----------------------------------------------------------------

     INSERT INTO IQ_INSPECT_MASTER_SAMPLE_LOG (
                                               ORGANIZATION_ID,
                                               INPUT_DATE,
                                               LINE_CODE,
                                               WORKSTAGE_CODE,
                                               MODEL_NAME,
                                               ITEM_CODE,
                                               PCB_ITEM,
                                               MASTER_SAMPLE_PID,
                                               ENTER_DATE,
                                               ENTER_BY,
                                               LAST_MODIFY_DATE,
                                               LAST_MODIFY_BY,
                                               AOI_MASTER_SAMPLE_CHECK
                                              )
     SELECT :NEW.ORGANIZATION_ID ,
            SYSDATE,
            :NEW.LINE_CODE,
            f_get_workstage_code_by_type('AOI'),
            :NEW.MODEL_NAME,
            :NEW.ITEM_CODE,
            :NEW.PCB_ITEM,
            :NEW.AOI_MASTER_SAMPLE_PID,
            SYSDATE,
            'TRIGGER',
            SYSDATE,
            'TRIGGER',
            :NEW.AOI_MASTER_SAMPLE_CHECK
       FROM DUAL;

  END IF;

EXCEPTION

  WHEN OTHERS THEN
       NULL ;

END;