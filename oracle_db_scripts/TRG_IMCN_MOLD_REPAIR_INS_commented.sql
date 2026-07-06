CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IMCN_MOLD_REPAIR_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IMCN_MOLD_REPAIR 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IMCN_MOLD_REPAIR - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.REPAIR_REASON_CODE - 신규/변경 후 값 값
   *   :NEW.REPAIR_VENDOR_CODE - 신규/변경 후 거래처 관련 값
   *   :NEW.MOLD_CODE - 신규/변경 후 값 값
   *   :NEW.MOLD_VERSION - 신규/변경 후 값 값
   *   :NEW.MOLD_SET_SERIAL - 신규/변경 후 시리얼 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_MOLD_REPAIR - 업무 데이터 트리거 대상 테이블
   *   IMCN_MOLD_INVENTORY - 재고 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: INSERT 1회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IMCN_MOLD_REPAIR_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IMCN_MOLD_REPAIR_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IMCN_MOLD_REPAIR_INS" 
 BEFORE
  INSERT
 ON imcn_mold_repair
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   IF :NEW.repair_reason_code = 'MJ31'
   THEN
      NULL;
   ELSE
      UPDATE imcn_mold_inventory
         SET mold_use_status = 'R',
             repair_vendor_code = :NEW.repair_vendor_code,
             last_issue_date = SYSDATE
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
