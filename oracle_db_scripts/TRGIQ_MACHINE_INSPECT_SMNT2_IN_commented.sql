CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIQ_MACHINE_INSPECT_SMNT2_IN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_SMNT2 테이블의 INSERT 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_SMNT2 - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MACHINE_CODE - 신규/변경 후 설비 관련 값
   *   :NEW.FEEDERBASEID - 신규/변경 후 값 값
   *   :NEW.SLOTNO - 신규/변경 후 값 값
   *   :NEW.PICKUP - 신규/변경 후 값 값
   *   :NEW.PLACE - 신규/변경 후 값 값
   *   :NEW.PICKERROR - 신규/변경 후 값 값
   *   :NEW.VISIONERROR - 신규/변경 후 값 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_SMNT2 - 설비 / 검사 관련 트리거 대상 테이블
   *   IQ_MACHINE_INSPECT_PICKUP - 설비 / 검사 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 2회, DELETE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIQ_MACHINE_INSPECT_SMNT2_IN';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIQ_MACHINE_INSPECT_SMNT2_IN';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGIQ_MACHINE_INSPECT_SMNT2_IN" 
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
