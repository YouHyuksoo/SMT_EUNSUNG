CREATE OR REPLACE TRIGGER "TRGICOM_TEMERATURE_RAW_INS"
  /* ================================================================
   * 트리거명  : TRGICOM_TEMERATURE_RAW_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ICOM_TEMPERATURE_RAW 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ICOM_TEMPERATURE_RAW - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.NODEID - 신규/변경 후 값 값
   *   :NEW.ATTRIBUTE01 - 신규/변경 후 값 값
   *   :NEW.ROOM_TEMPERATURE - 신규/변경 후 값 값
   *   :NEW.HUMIDITY - 신규/변경 후 값 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.GATHER_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.GW_ID - 신규/변경 후 값 값
   *   :NEW.LQI - 신규/변경 후 값 값
   *   :NEW.CHILD_CNT - 신규/변경 후 값 값
   *   :NEW.NODETYPE - 신규/변경 후 값 값
   *   :NEW.BATT - 신규/변경 후 값 값
   *   :NEW.DEW_POINT - 신규/변경 후 값 값
   *   :NEW.SD4 - 신규/변경 후 값 값
   *   :NEW.ATTRIBUTE02 - 신규/변경 후 값 값
   *   :NEW.ATTRIBUTE03 - 신규/변경 후 값 값
   *   :NEW.ATTRIBUTE04 - 신규/변경 후 값 값
   *   :NEW.ATTRIBUTE05 - 신규/변경 후 값 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.ENTER_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_TEMPERATURE_RAW - 업무 데이터 트리거 대상 테이블
   *   ICOM_TEMPERATURE_DATA - 업무 데이터 트리거 내부 SQL에서 참조/변경
   *   IMCN_MACHINE - 설비 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 0회
   *   DML: SELECT 3회, INSERT 3회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGICOM_TEMERATURE_RAW_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGICOM_TEMERATURE_RAW_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

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
