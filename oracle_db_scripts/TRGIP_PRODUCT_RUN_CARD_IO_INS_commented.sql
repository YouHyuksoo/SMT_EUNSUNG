CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIP_PRODUCT_RUN_CARD_IO_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_RUN_CARD_IO 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_RUN_CARD_IO - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.WORKSTAGE_CODE - 신규/변경 후 공정 관련 값
   *   :NEW.MODEL_NAME - 신규/변경 후 모델 / 명칭 관련 값
   *   :NEW.MODEL_SUFFIX - 신규/변경 후 모델 관련 값
   *   :NEW.PCB_ITEM - 신규/변경 후 PCB / 품목 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.LOT_QTY - 신규/변경 후 LOT / 수량 관련 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_CARD_IO - 제품 / 작업지시/런 관련 트리거 대상 테이블
   *   IP_PRODUCT_RUN_CARD_INV - 제품 / 작업지시/런 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 2회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIP_PRODUCT_RUN_CARD_IO_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIP_PRODUCT_RUN_CARD_IO_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGIP_PRODUCT_RUN_CARD_IO_INS" 
 BEFORE
  INSERT
 ON ip_product_run_card_io
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvi_count   NUMBER;
BEGIN
    BEGIN
        SELECT   COUNT ( * )
          INTO   lvi_count
          FROM   ip_product_run_card_inv
         WHERE   line_code = :new.line_code
             AND workstage_code = :new.workstage_code
             AND model_name = :new.model_name
             AND model_suffix = :new.model_suffix
             AND pcb_item = :new.pcb_item
             AND organization_id = :new.organization_id;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvi_count := 0;
    END;

    IF lvi_count = 0
    THEN
        INSERT INTO ip_product_run_card_inv (item_code,
                                             model_name,
                                             model_suffix,
                                             line_code,
                                             workstage_code,
                                             inventory_qty,
                                             organization_id,
                                             enter_date,
                                             enter_by,
                                             last_modify_date,
                                             last_modify_by,
                                             pcb_item)
          VALUES   (:new.item_code,
                    :new.model_name,
                    :new.model_suffix,
                    :new.line_code,
                    :new.workstage_code,
                    :new.lot_qty,
                    :new.organization_id,
                    SYSDATE,
                    :new.enter_by,
                    SYSDATE,
                    :new.last_modify_by,
                    :new.pcb_item);
    ELSE
        UPDATE   ip_product_run_card_inv
           SET   inventory_qty = inventory_qty + :new.lot_qty
         WHERE   line_code = :new.line_code
             AND workstage_code = :new.workstage_code
             AND model_name = :new.model_name
             AND model_suffix = :new.model_suffix
             AND pcb_item = :new.pcb_item
             AND organization_id = :new.organization_id;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;
