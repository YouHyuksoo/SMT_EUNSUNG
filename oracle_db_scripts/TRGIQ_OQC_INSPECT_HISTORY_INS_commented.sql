CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIQ_OQC_INSPECT_HISTORY_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_OQC_INSPECT_HISTORY 테이블의 INSERT 발생 시 변경 이력 또는 감사 로그를 자동 기록한다.
   *   원본 로직 기준으로 변경 전후 값과 처리 정보를 보조 테이블에 남기는 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_OQC_INSPECT_HISTORY - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.PRODUCT_ID - 신규/변경 후 제품 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_OQC_INSPECT_HISTORY - 검사 / 이력 관련 트리거 대상 테이블
   *   IP_PRODUCT_2D_BARCODE - 제품 / 바코드 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: INSERT 1회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIQ_OQC_INSPECT_HISTORY_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIQ_OQC_INSPECT_HISTORY_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGIQ_OQC_INSPECT_HISTORY_INS" 
 AFTER 
 INSERT
 ON IQ_OQC_INSPECT_HISTORY
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
BEGIN
   
    UPDATE ip_product_2d_barcode
       SET qc_scan_yn = 'Y', qc_scan_date = SYSDATE
     WHERE serial_no = :new.PRODUCT_ID ;
     
END;
