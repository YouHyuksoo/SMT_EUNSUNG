CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_ISAL_SHIPPING_LOT_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ISAL_SHIPPING_LOT_MASTER 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ISAL_SHIPPING_LOT_MASTER - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LOT_COMPLETE_YN - 신규/변경 후 LOT 관련 값
   *   :NEW.LOT_NO - 신규/변경 후 LOT 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISAL_SHIPPING_LOT_MASTER - LOT 관련 트리거 대상 테이블
   *   ISAL_SHIPPING_LOT_DETAIL - LOT 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ISAL_SHIPPING_LOT_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ISAL_SHIPPING_LOT_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_ISAL_SHIPPING_LOT_UPD" 
 AFTER
   UPDATE OF lot_complete_yn
 ON isal_shipping_lot_master
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   UPDATE isal_shipping_lot_detail
      SET LOT_COMPLETE_YN = :NEW.LOT_COMPLETE_YN
    WHERE lot_no = :NEW.lot_no;
END;
