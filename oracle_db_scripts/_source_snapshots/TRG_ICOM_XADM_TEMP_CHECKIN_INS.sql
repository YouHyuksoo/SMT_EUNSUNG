TRIGGER "INFINITY21_JSMES"."TRG_ICOM_XADM_TEMP_CHECKIN_INS" 
  before insert on xxadm_temprature_check_in
  for each row
declare
  -- local variables here
begin

  -- 온도계가 체크인 할때
  MERGE INTO IMCN_MACHINE X
  USING DUAL
  ON (      x.organization_id = 1
       AND  x.machine_code    = upper(:new.a_mac)
  )
  WHEN MATCHED THEN
    UPDATE
       SET X.IP_ADDRESS = :NEW.A_IP

  WHEN NOT MATCHED THEN

    INSERT   (  organization_id,
                machine_code,
                machine_name,
                machine_type,
                line_code,
                workstage_code,
                acquisition_type,
                ip_address,
                use_status,
                enter_date,
                enter_by)
    VALUES   (1,
              UPPER (:new.a_mac),
              UPPER (:new.a_mac),
              'TEMP',
              '*',
              '*',
              'A',
              :new.a_ip,
              'Y',
              SYSDATE,
              'SYSTEM')
   ;


end TRG_ICOM_XADM_TEMP_CHECKIN_INS;

