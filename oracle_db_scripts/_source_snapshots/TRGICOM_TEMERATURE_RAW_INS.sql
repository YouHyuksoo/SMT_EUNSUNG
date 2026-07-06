TRIGGER "TRGICOM_TEMERATURE_RAW_INS"
 BEFORE
 INSERT
 ON ICOM_TEMPERATURE_RAW
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    lvi_count            NUMBER;

    lvi_temp_offset      NUMBER;
    lvi_humidity_offset  NUMBER;

BEGIN


    :new.nodeid := UPPER (:new.nodeid);

    -----------------------------------------------
    -- 설비코드가 등록되어 있는지 확인
    -----------------------------------------------

    BEGIN
        SELECT   COUNT ( * )
          INTO   lvi_count
          FROM   icom_temperature_data
         WHERE   UPPER (nodeid) = UPPER (:new.nodeid);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             lvi_count := 0;
    END;

    -----------------------------------------------
    -- Offset 적용
    -----------------------------------------------

    BEGIN

       select nvl(temp_offset,0), nvl(humidity_offset,0)
         into lvi_temp_offset, lvi_humidity_offset
         from imcn_machine
        where machine_code    = UPPER (:new.nodeid)
          and organization_id = 1
          and rownum          = 1;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            lvi_temp_offset      := 0;
            lvi_humidity_offset  := 0;
    END;

    --외부 센서가 있으면 외부 센서로 값 대체 
    if  :new.attribute01 ='NULL' OR :new.attribute01 IS NULL THEN 
         null ;
    else
        :new.room_temperature  := TO_NUMBER(:new.attribute01)  ;
    end if ;
    
    

    :new.room_temperature := :new.room_temperature + ( lvi_temp_offset );
    :new.humidity         := :new.humidity + ( lvi_humidity_offset );


   
    -------------------------------------------------
    -- 설비코드가 등록되어지 않으면 imcn_machine 에 등록
    -------------------------------------------------

    IF lvi_count = 0 THEN

        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_count
              FROM   imcn_machine
             WHERE   machine_code = UPPER (:new.nodeid);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 lvi_count := 0;
        END;

        IF lvi_count = 0 THEN

            INSERT INTO imcn_machine (organization_id,
                                      machine_code,
                                      machine_name,
                                      machine_type,
                                      line_code,
                                      workstage_code,
                                      acquisition_type,
                                      use_status,
                                      enter_date,
                                      enter_by)
              VALUES   (:new.organization_id,
                        UPPER (:new.nodeid),
                        UPPER (:new.nodeid),
                        'TEMP',
                        '*',
                        '*',
                        'A',
                        'Y',
                        SYSDATE,
                        'SYSTEM');
        END IF;

    -----------------------------------------------
    -- 최근데이타 등록
    -----------------------------------------------

        INSERT INTO icom_temperature_data (organization_id,
                                           gather_date,
                                           gw_id,
                                           nodeid,
                                           lqi,
                                           child_cnt,
                                           nodetype,
                                           batt,
                                           room_temperature,
                                           humidity,
                                           dew_point,
                                           sd4,
                                           attribute01,
                                           attribute02,
                                           attribute03,
                                           attribute04,
                                           attribute05,
                                           enter_by,
                                           enter_date,
                                           last_modify_by,
                                           last_modify_date)
          VALUES   (:new.organization_id,
                    :new.gather_date,
                    :new.gw_id,
                    UPPER (:new.nodeid),
                    :new.lqi,
                    :new.child_cnt,
                    :new.nodetype,
                    :new.batt,
                    CASE WHEN :new.attribute01 ='NULL' OR :new.attribute01 IS NULL THEN :new.room_temperature  ELSE TO_NUMBER(:new.attribute01) + ( lvi_temp_offset ) END ,
                    :new.humidity,
                    :new.dew_point,
                    :new.sd4,
                    :new.attribute01,
                    :new.attribute02,
                    :new.attribute03,
                    :new.attribute04,
                    :new.attribute05,
                    :new.enter_by,
                    :new.enter_date,
                    :new.last_modify_by,
                    :new.last_modify_date);
    ELSE

        UPDATE   icom_temperature_data
           SET   gather_date = SYSDATE,
                 batt = :new.batt,
                 room_temperature =  CASE WHEN :new.attribute01 ='NULL' OR :new.attribute01 IS NULL THEN :new.room_temperature  ELSE TO_NUMBER(:new.attribute01) + ( lvi_temp_offset ) END , --:new.room_temperature,
                 humidity = :new.humidity,
                 dew_point = :new.dew_point,
                 nodeid = UPPER (:new.nodeid) ,
                 lqi = :new.lqi ,
                 gw_id = :NEW.GW_ID
         WHERE   UPPER (nodeid) = UPPER (:new.nodeid);

    END IF;

EXCEPTION
    WHEN OTHERS THEN
         raise_application_error (-20003, SQLERRM);
         NULL;
END;
