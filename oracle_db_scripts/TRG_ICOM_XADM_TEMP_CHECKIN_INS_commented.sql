CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_ICOM_XADM_TEMP_CHECKIN_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   XXADM_TEMPRATURE_CHECK_IN 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   XXADM_TEMPRATURE_CHECK_IN - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.A_MAC - 신규/변경 후 값 값
   *   :NEW.A_IP - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   XXADM_TEMPRATURE_CHECK_IN - 업무 데이터 트리거 대상 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: INSERT 2회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ICOM_XADM_TEMP_CHECKIN_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ICOM_XADM_TEMP_CHECKIN_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_ICOM_XADM_TEMP_CHECKIN_INS" 
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
