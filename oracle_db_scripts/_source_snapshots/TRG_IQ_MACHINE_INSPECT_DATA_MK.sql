TRIGGER "INFINITY21_JSMES".TRG_IQ_MACHINE_INSPECT_DATA_MK
  after insert on iq_machine_inspect_data_mk  
  for each row
declare
  /*SMT 공정 통과 WORKSTAGE IO 에 입력 테스트*/
  V_OUT VARCHAR2(4000); 
  V_MSG VARCHAR2(4000); 
begin
  


/* 

 IF :NEW.PID = 'NULL' OR :NEW.PID IS NULL THEN 
    NULL ; \*만들지 말자*\
  ELSE 
    \*공정 in-out DATA 만들기*\
    P_SET_WORKSTAGE_SCAN_IN( :NEW.PID,
                             :NEW.EQUIPMENTID, 
                             'W030',                --마킹공정 
                             :NEW.ORGANIZATION_ID, 
                             'I',
                             V_OUT, 
                             V_MSG ) ; 
 END IF ; 
 
 */

 
 NULL;
 
EXCEPTION 
  WHEN OTHERS THEN 
    NULL ; 

end TRG_IQ_MACHINE_INSPECT_DATA_MK;
