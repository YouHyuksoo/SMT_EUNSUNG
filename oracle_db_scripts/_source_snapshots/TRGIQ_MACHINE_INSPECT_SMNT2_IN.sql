TRIGGER "INFINITY21_JSMES"."TRGIQ_MACHINE_INSPECT_SMNT2_IN" 
 BEFORE
  INSERT
 ON iq_machine_inspect_smnt2
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvi_count       NUMBER;
    lvf_tact_time   NUMBER;
    lvs_line_code   VARCHAR2 (10);
BEGIN

    lvs_line_code := TRIM (TO_CHAR (SUBSTR (:new.line_code, 1, length(:new.line_code) - 1), '00'));


    SELECT   COUNT ( * ), max ( (SYSDATE - enter_date) * 24 * 60 * 60)
      INTO   lvi_count, lvf_tact_time
      FROM   iq_machine_inspect_pickup
     WHERE   line_code = lvs_line_code
         AND machine_code = :new.machine_code
         AND feederbaseid = :new.feederbaseid
          AND trim(slotno) = trim(:new.slotno) ;

    IF lvi_count > 0
    THEN
        DELETE   iq_machine_inspect_pickup
         WHERE   line_code = lvs_line_code
             AND machine_code = :new.machine_code
             AND feederbaseid = :new.feederbaseid
             AND trim(slotno) = trim(:new.slotno);
    END IF;


    INSERT INTO iq_machine_inspect_pickup (line_code,
                                           machine_code,
                                           feederbaseid,
                                           slotno,
                                           pickup,
                                           place,
                                           pickerror,
                                           visionerror,
                                           enter_date,
                                           last_modify_date,
                                           enter_by,
                                           last_modify_by,
                                           organization_id,
                                           tact_time)
      VALUES   (lvs_line_code,
                :new.machine_code,
                :new.feederbaseid,
                trim(:new.slotno),
                :new.pickup,
                :new.place,
                :new.pickerror,
                :new.visionerror,
                SYSDATE,
                SYSDATE,
                'SYSTEM',
                'SYSTEM',
                :new.organization_id,
                lvf_tact_time);
END;