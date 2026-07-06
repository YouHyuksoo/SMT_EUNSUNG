CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IM_ITEM_SALE_INVOICE_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_SALE_INVOICE_MASTER 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_SALE_INVOICE_MASTER - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.INVOICE_OPEN_YN - 신규/변경 후 값 값
   *   :OLD.INVOICE_OPEN_SEQUENCE - 변경/삭제 전 값 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_SALE_INVOICE_MASTER - 품목 관련 트리거 대상 테이블
   *   IM_ITEM_SALE_RECEIPT - 품목 / 입고 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 1회 / 반복문: 0회
   *   DML: UPDATE 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IM_ITEM_SALE_INVOICE_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IM_ITEM_SALE_INVOICE_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IM_ITEM_SALE_INVOICE_UPD" 
 AFTER
  UPDATE
 ON im_item_sale_invoice_master
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   IF :NEW.invoice_open_yn = 'Y'
   THEN
      UPDATE im_item_sale_receipt
         SET invoice_open_yn = 'Y'
       WHERE invoice_open_sequence = :OLD.invoice_open_sequence
         AND organization_id = :OLD.organization_id
         AND invoice_open_yn = 'R';
   ELSIF :NEW.invoice_open_yn = 'R'
   THEN
      UPDATE im_item_sale_receipt
         SET invoice_open_yn = 'R'
       WHERE invoice_open_sequence = :OLD.invoice_open_sequence
         AND organization_id = :OLD.organization_id
         AND invoice_open_yn = 'Y';
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
