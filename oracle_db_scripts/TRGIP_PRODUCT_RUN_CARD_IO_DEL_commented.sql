CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIP_PRODUCT_RUN_CARD_IO_DEL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_RUN_CARD_IO 테이블의 DELETE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: DELETE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_RUN_CARD_IO - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :OLD.LOT_QTY - 변경/삭제 전 LOT / 수량 관련 값
   *   :OLD.LINE_CODE - 변경/삭제 전 라인 관련 값
   *   :OLD.WORKSTAGE_CODE - 변경/삭제 전 공정 관련 값
   *   :OLD.MODEL_NAME - 변경/삭제 전 모델 / 명칭 관련 값
   *   :OLD.MODEL_SUFFIX - 변경/삭제 전 모델 관련 값
   *   :OLD.PCB_ITEM - 변경/삭제 전 PCB / 품목 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_CARD_IO - 제품 / 작업지시/런 관련 트리거 대상 테이블
   *   IP_PRODUCT_RUN_CARD_INV - 제품 / 작업지시/런 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: UPDATE 1회, DELETE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIP_PRODUCT_RUN_CARD_IO_DEL';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIP_PRODUCT_RUN_CARD_IO_DEL';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGIP_PRODUCT_RUN_CARD_IO_DEL" 
 BEFORE
  DELETE
 ON ip_product_run_card_io
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN


      UPDATE   ip_product_run_card_inv
           SET   inventory_qty = inventory_qty - :old.lot_qty
         WHERE   line_code = :old.line_code
             AND workstage_code = :old.workstage_code
             AND model_name = :old.model_name
             AND model_suffix = :old.model_suffix
             AND pcb_item = :old.pcb_item
             AND organization_id = :old.organization_id;


END ;
