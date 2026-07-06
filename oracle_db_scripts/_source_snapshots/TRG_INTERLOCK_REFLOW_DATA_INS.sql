TRIGGER "INFINITY21_JSMES"."TRG_INTERLOCK_REFLOW_DATA_INS" 
  before insert on iq_interlock_reflow_data
  for each row
declare
  -- local variables here
  lvs_PF_TYPE varchar2(1) ;
begin
/*  CHECK_DATE, ENTER_DATE, FILE_NAME, instr(FILE_NAME,'？？？？',1) , instr(FILE_NAME,'？？？？',1)
  DECODE( SIGN(instr(FILE_NAME,'？？？？',1) - instr(FILE_NAME,'？？？？',1)),1,'？？？？',-1,'？？？？')

    substr(CHECK_DATE,1,10),
       TRIM(substr(CHECK_DATE,11,4)),
       substr(CHECK_DATE,15,10) */

    SELECT DECODE( SIGN(instr(:NEW.FILE_NAME,'？？？？',1) - instr(:NEW.FILE_NAME,'？？？？',1)),1,'F',-1,'P')
      INTO lvs_pf_type
      FROM DUAL ;

   :NEW.PF_TYPE := lvs_pf_type ;
exception
  when others then
    null ;
end TRG_interlock_reflow_data_ins;