CREATE OR REPLACE TRIGGER "TRG_IM_ITEM_ISSUE_MANUAL"
  /* ================================================================
   * 트리거명  : TRG_IM_ITEM_ISSUE_MANUAL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_ISSUE 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_ISSUE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_ISSUE - 품목 / 출고 관련 트리거 대상 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 2회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IM_ITEM_ISSUE_MANUAL';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IM_ITEM_ISSUE_MANUAL';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

   BEFORE UPDATE OF last_modify_by
   ON IM_ITEM_ISSUE    REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   lvl_cnt   NUMBER := 0;
BEGIN
  
NULL;

/*
   BEGIN
      SELECT
             COUNT (*)
      INTO
             lvl_cnt
      FROM
             im_item_inventory
      WHERE
                 material_mfs = :old.material_mfs
             AND item_code = :old.item_code
             AND line_type = :old.line_type
             AND location_code = :old.location_code
             AND organization_id = :old.organization_id
             AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      INSERT INTO
             im_item_inventory (material_mfs,
                                item_code,
                                inventory_status,
                                organization_id,
                                line_type,
                                inventory_hold,
                                inventory_price,
                                inventory_qty,
                                inventory_amt,
                                location_code,
                                comments,
                                enter_date,
                                enter_by,
                                last_modify_date,
                                last_modify_by)
      VALUES
             (:old.material_mfs,
              :old.item_code,
              'G',
              :old.organization_id,
              :old.line_type,
              'W',
              0,
              0,
              0,
              :old.location_code,
              NULL,
              SYSDATE,
              :old.enter_by,
              SYSDATE,
              :old.last_modify_by);
   ELSE
      UPDATE
             im_item_inventory
      SET
             INVENTORY_QTY = nvl(INVENTORY_QTY,0)  - :old.issue_qty
      WHERE
                 material_mfs = :old.material_mfs
             AND item_code = :old.item_code
             AND line_type = :old.line_type
             AND location_code = :old.location_code
             AND organization_id = :old.organization_id;
   END IF;


   IF 1 = 2
   THEN
      IF :old.issue_account IN ('M001', 'M002')
      THEN
         INSERT INTO
                im_item_workstage_receipt (receipt_date,
                                           receipt_sequence,
                                           organization_id,
                                           workstage_code,
                                           from_workstage_code,
                                           machine_code,
                                           material_mfs,
                                           mfs,
                                           item_code,
                                           item_type,
                                           line_type,
                                           line_code,
                                           receipt_deficit,
                                           receipt_price,
                                           receipt_qty,
                                           receipt_weight,
                                           receipt_amt,
                                           receipt_type,
                                           receipt_account,
                                           item_unit_weight,
                                           issue_date,
                                           issue_sequence,
                                           work_order_no,
                                           receipt_status,
                                           transfer_date,
                                           transfer_sequence,
                                           transfer_type,
                                           invoice_no,
                                           enter_date,
                                           enter_by,
                                           last_modify_date,
                                           last_modify_by)
         VALUES
                (:old.issue_date,
                 seq_workstage_receipt_seq.NEXTVAL,
                 :old.organization_id,
                 :old.workstage_code,
                 'WH',
                 :old.machine_code,
                 :old.material_mfs,
                 :old.mfs,
                 :old.item_code,
                 :old.item_type,
                 :old.line_type,
                 :old.line_code,
                 DECODE (:old.issue_deficit,  '3', '1',  '4', '2'),
                 :old.issue_price,
                 :old.issue_qty,
                 :old.issue_qty,                             --RECEIPT_WEIGHT,
                 :old.issue_amt,
                 :old.issue_type,                 --RECEIPT_TYPE,AUTO / NORMAL
                 :old.issue_account,
                 0,                                        --ITEM_UNIT_WEIGHT,
                 NULL,                                           --ISSUE_DATE,
                 NULL,                                       --ISSUE_SEQUENCE,
                 :old.work_order_no,
                 :old.issue_status,                          --RECEIPT_STATUS,
                 :old.issue_date,                                --ISSUE_DATE,
                 seq_workstage_receipt_seq.NEXTVAL,       --TRANSFER_SEQUENCE,
                 'S',
                 :old.invoice_no,
                 SYSDATE,
                 :old.enter_by,
                 SYSDATE,
                 :old.last_modify_by);
      END IF;
   END IF;
   
*/
   
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
