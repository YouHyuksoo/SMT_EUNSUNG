TRIGGER "INFINITY21_JSMES"."TRG_XADM_TEMP_DATA_IN_INS" 
  before insert on xxadm_temprature_data_in
  for each row
declare
  -- local variables here
begin
   /*
    C000 --> 현재값,
    P000 --> 과거값
    P0XX --> 과거값   1분마다 집계 5분마다 전송시  5개의 데이터가 올라옴
    select C000,
        SUBSTR(C000,                          1, INSTR(C000, '|', 1, 1) - 1)                          GATHER_DATE,
        SUBSTR(C000, INSTR(C000, '|', 1, 1) + 1, INSTR(C000, '|', 1, 2) - INSTR(C000, '|', 1, 1) - 1) TEMPRATURE,
        SUBSTR(C000, INSTR(C000, '|', 1, 2) + 1, INSTR(C000, '|', 1, 3) - INSTR(C000, '|', 1, 2) - 1) Humidity,
        SUBSTR(C000, INSTR(C000, '|', 1, 3) + 1, INSTR(C000, '|', 1, 4) - INSTR(C000, '|', 1, 3) - 1) ExtraValue
*/      /*organization_id, mac, signal, bat, smodel,

        SUBSTR(C000,                          1, INSTR(C000, '|', 1, 1) - 1)                          GATHER_DATE,
        SUBSTR(C000, INSTR(C000, '|', 1, 1) + 1, INSTR(C000, '|', 1, 2) - INSTR(C000, '|', 1, 1) - 1) TEMPRATURE,
        SUBSTR(C000, INSTR(C000, '|', 1, 2) + 1, INSTR(C000, '|', 1, 3) - INSTR(C000, '|', 1, 2) - 1) Humidity,
        SUBSTR(C000, INSTR(C000, '|', 1, 3) + 1, INSTR(C000, '|', 1, 4) - INSTR(C000, '|', 1, 3) - 1) ExtraValue

  from xxadm_temprature_data_in X   ; */
if :NEW.C000 is null then 
  INSERT INTO ICOM_TEMPERATURE_RAW (
          organization_id,
          gather_date,
          gw_id,
          nodeid,
          lqi,
          --child_cnt,
          nodetype,
          batt,
          room_temperature,
          humidity,
          --dew_point,   --NUMBER
          --sd4,         --NUMBER
          attribute01,
          attribute02
          --attribute03,
          --attribute04,
          --attribute05,
          --enter_by,
          --enter_date,
          --last_modify_by,
          --last_modify_date

  ) VALUES (
          :NEW.ORGANIZATION_ID,
          UNIX_TS_TO_DATE(SUBSTR(:NEW.P000,1, INSTR(:NEW.P000, '|', 1, 1) - 1)),
          'WIFI',
          :NEW.MAC,
          :NEW.SIGNAL,
          1,
          :NEW.BAT,
          REPLACE(SUBSTR(:NEW.P000, INSTR(:NEW.P000, '|', 1, 1) + 1, INSTR(:NEW.P000, '|', 1, 2) - INSTR(:NEW.P000, '|', 1, 1) - 1),'nan','0.00'),
          REPLACE(SUBSTR(:NEW.P000, INSTR(:NEW.P000, '|', 1, 2) + 1, INSTR(:NEW.P000, '|', 1, 3) - INSTR(:NEW.P000, '|', 1, 2) - 1),'nan','0.00'),
          SUBSTR(:NEW.P000, INSTR(:NEW.P000, '|', 1, 3) + 1, INSTR(:NEW.P000, '|', 1, 4) - INSTR(:NEW.P000, '|', 1, 3) - 1), --aTTRIBUTE01 EXTRA
          :NEW.P000
  ) ;
  
else
  INSERT INTO ICOM_TEMPERATURE_RAW (
          organization_id,
          gather_date,
          gw_id,
          nodeid,
          lqi,
          --child_cnt,
          nodetype,
          batt,
          room_temperature,
          humidity,
          --dew_point,   --NUMBER
          --sd4,         --NUMBER
          attribute01,
          attribute02
          --attribute03,
          --attribute04,
          --attribute05,
          --enter_by,
          --enter_date,
          --last_modify_by,
          --last_modify_date

  ) VALUES (
          :NEW.ORGANIZATION_ID,
          UNIX_TS_TO_DATE(SUBSTR(:NEW.C000,1, INSTR(:NEW.C000, '|', 1, 1) - 1)),
          'WIFI',
          :NEW.MAC,
          :NEW.SIGNAL,
          1,
          :NEW.BAT,
          REPLACE(SUBSTR(:NEW.C000, INSTR(:NEW.C000, '|', 1, 1) + 1, INSTR(:NEW.C000, '|', 1, 2) - INSTR(:NEW.C000, '|', 1, 1) - 1),'nan','0.00'),
          REPLACE(SUBSTR(:NEW.C000, INSTR(:NEW.C000, '|', 1, 2) + 1, INSTR(:NEW.C000, '|', 1, 3) - INSTR(:NEW.C000, '|', 1, 2) - 1),'nan','0.00'),
          SUBSTR(:NEW.C000, INSTR(:NEW.C000, '|', 1, 3) + 1, INSTR(:NEW.C000, '|', 1, 4) - INSTR(:NEW.C000, '|', 1, 3) - 1), --aTTRIBUTE01 EXTRA
          :NEW.C000
  ) ;
  
  
  end if ;

EXCEPTION
  WHEN OTHERS THEN
         ps_job_errorlog(898,:NEW.ORGANIZATION_ID,'TRG_XADM_TEMP_DATA_IN_INS','온도입력',:NEW.C000||SUBSTR(SQLERRM,1,200),'FFF');
end TRG_XADM_TEMP_DATA_IN_INS;