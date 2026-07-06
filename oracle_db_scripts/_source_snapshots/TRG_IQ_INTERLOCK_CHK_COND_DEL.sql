TRIGGER TRG_IQ_INTERLOCK_CHK_COND_DEL
  before delete on iq_interlock_check_condition
  for each row
declare
  -- local variables here
begin

          -- Interlock condition update？？？？？？？？？

          INSERT INTO IQ_INTERLOCK_CHECK_COND_LOG (ORGANIZATION_ID,
                                                   LINE_CODE,
                                                   WORKSTAGE_CODE,
                                                   MACHINE_CODE,
                                                   INTERLOCK_CHECK_TYPE,
                                                   OLD_CHECK_LIMT_TIME,
                                                   OLD_CHECK_SEQUENCE,
                                                   OLD_ITEM_CODE,
                                                   OLD_USE_YN,
                                                   OLD_MODIFY_DATE,
                                                   OLD_MODIFY_BY,
                                                   
                                                   NEW_CHECK_LIMT_TIME,
                                                   NEW_CHECK_SEQUENCE,
                                                   NEW_ITEM_CODE,
                                                   NEW_USE_YN,
                                                   NEW_MODIFY_DATE,
                                                   NEW_MODIFY_BY,
                                                   
                                                   TERMINAL,
                                                   CURRENT_USER,
                                                   HOST,
                                                   IP_ADDRESS,
                                                   TRIGGER_MODE,
                                                   TRIGGER_DATE
                                                  )
        SELECT :OLD.ORGANIZATION_ID,
               :OLD.LINE_CODE,
               :OLD.WORKSTAGE_CODE,
               :OLD.MACHINE_CODE,
               :OLD.INTERLOCK_CHECK_TYPE,
               :OLD.CHECK_LIMT_TIME,
               :OLD.CHECK_SEQUENCE,
               :OLD.ITEM_CODE,
               :OLD.USE_YN,
               :OLD.LAST_modify_date,
               :OLD.LAST_MODIFY_BY,
               
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               
               SYS_CONTEXT('USERENV','TERMINAL'),     -- terminal ,
               SYS_CONTEXT('USERENV','CURRENT_USER'), -- current_user,
               SYS_CONTEXT('USERENV','HOST'),         -- host,
               SYS_CONTEXT('USERENV','IP_ADDRESS'),   -- ip_address,
               'DELETE',
               SYSDATE
               
          FROM DUAL;

	EXCEPTION
    
   WHEN OTHERS THEN
        raise_application_error (-20003, SQLERRM);

end;
