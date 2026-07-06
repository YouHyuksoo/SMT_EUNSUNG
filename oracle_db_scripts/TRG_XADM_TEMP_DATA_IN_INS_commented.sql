CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_XADM_TEMP_DATA_IN_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   XXADM_TEMPRATURE_DATA_IN 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   XXADM_TEMPRATURE_DATA_IN - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.C000 - 신규/변경 후 값 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.P000 - 신규/변경 후 값 값
   *   :NEW.MAC - 신규/변경 후 값 값
   *   :NEW.SIGNAL - 신규/변경 후 값 값
   *   :NEW.BAT - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   XXADM_TEMPRATURE_DATA_IN - 업무 데이터 트리거 대상 테이블
   *   ICOM_TEMPERATURE_RAW - 업무 데이터 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   PS_JOB_ERRORLOG - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_XADM_TEMP_DATA_IN_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_XADM_TEMP_DATA_IN_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_XADM_TEMP_DATA_IN_INS" 
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
