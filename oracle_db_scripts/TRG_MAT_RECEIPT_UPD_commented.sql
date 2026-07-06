CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_MAT_RECEIPT_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_RECEIPT 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_RECEIPT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :OLD.LOCATION_CODE - 변경/삭제 전 값 값
   *   :OLD.MATERIAL_MFS - 변경/삭제 전 자재 관련 값
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.LINE_TYPE - 변경/삭제 전 라인 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.UNIT_PRICE - 변경/삭제 전 단가 관련 값
   *   :OLD.RECEIPT_QTY - 변경/삭제 전 입고 / 수량 관련 값
   *   :OLD.EXCHANGE_RATE - 변경/삭제 전 율 관련 값
   *   :OLD.MATERIAL_COST_AMT - 변경/삭제 전 자재 관련 값
   *   :OLD.ENTER_BY - 변경/삭제 전 값 값
   *   :OLD.LAST_MODIFY_BY - 변경/삭제 전 값 값
   *   :OLD.MANUFACTURE_DATE - 변경/삭제 전 일자 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_RECEIPT - 품목 / 입고 관련 트리거 대상 테이블
   *   IM_ITEM_INVENTORY - 품목 / 재고 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 10회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 3회, UPDATE 7회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_MAT_RECEIPT_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_MAT_RECEIPT_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_MAT_RECEIPT_UPD"
 AFTER
   UPDATE OF last_modify_date
 ON IM_ITEM_RECEIPT REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvl_cnt                     NUMBER := 0;
    lvi_return                  NUMBER;
    lvf_last_dd_avg_price       NUMBER;
    lvf_last_dd_inventory_qty   NUMBER;
    lvf_last_dd_inventory_amt   NUMBER;
    lvf_arrival_qty             NUMBER;
    lvf_arrival_amt             NUMBER;
    lvf_mm_receipt_qty          NUMBER;
    lvf_mm_receipt_amt          NUMBER;
    lvf_mm_issue_qty            NUMBER;
    lvf_mm_issue_amt            NUMBER;
    lvf_mm_free_issue_qty       NUMBER;
    lvf_mm_free_issue_amt       NUMBER;
    lvf_last_inventory_qty      NUMBER;
    lvf_last_avg_price          NUMBER;
    lvf_last_inventory_amt      NUMBER;
BEGIN
    -------------------------------------
    -- current inventory get
    -------------------------------------

  --  if 1 = 2 then

    BEGIN
        SELECT   COUNT ( * )
          INTO   lvl_cnt
          FROM   im_item_inventory
         WHERE       location_code = :old.location_code
                 AND material_mfs = :old.material_mfs
                 AND item_code = :old.item_code
                 AND line_type = :old.line_type
                 AND organization_id = :old.organization_id
                 AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvl_cnt := 0;
    END;

    IF lvl_cnt < 1
    THEN
        lvf_last_inventory_qty := 0;
        lvf_last_avg_price := 0;
        lvf_last_inventory_amt := 0;

        INSERT INTO im_item_inventory (material_mfs,
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
                                       last_modify_by,
                                       last_receipt_date,
                                       manufacture_date)
          VALUES   (:old.material_mfs,
                    :old.item_code,
                    'G',
                    :old.organization_id,
                    :old.line_type,
                    'W',
                    :old.unit_price,
                    :old.receipt_qty,
                    (:old.exchange_rate * :old.unit_price * :old.receipt_qty)
                    + NVL (:old.material_cost_amt, 0),
                    :old.location_code,
                    NULL,
                    SYSDATE,
                    :old.enter_by,
                    SYSDATE,
                    :old.last_modify_by,
                    SYSDATE,
                    :old.manufacture_date);
   --    ELSE
    /*       SELECT inventory_qty, inventory_price,
                  inventory_amt
             INTO lvf_last_inventory_qty, lvf_last_avg_price,
                  lvf_last_inventory_amt
             FROM im_item_inventory
            WHERE material_mfs = :OLD.material_mfs
              AND item_code = :OLD.item_code
              AND line_type = :OLD.line_type
              AND organization_id = :OLD.organization_id;

           UPDATE im_item_inventory
              SET inventory_qty =   NVL (inventory_qty, 0)
                                  + :OLD.receipt_qty,
                  inventory_amt =   NVL (inventory_amt, 0)
                                  + (  :OLD.receipt_qty
                                     * :OLD.unit_price
                                     * :OLD.exchange_rate
                                    )
                                  + NVL (:OLD.material_cost_amt, 0),
                  location_code = :OLD.location_code
            WHERE material_mfs = :OLD.material_mfs
              AND item_code = :OLD.item_code
              AND line_type = :OLD.line_type
              AND organization_id = :OLD.organization_id;

           UPDATE im_item_inventory
              SET inventory_price =
                     DECODE (inventory_qty, 0, 0, inventory_amt / inventory_qty)
            WHERE material_mfs = :OLD.material_mfs
              AND item_code = :OLD.item_code
              AND line_type = :OLD.line_type
              AND organization_id = :OLD.organization_id;*/

     --      NULL;
    --   END IF;


    ----------------------------------------------------
    -- ITEM LEDGER INSERT
    ----------------------------------------------------
    /*
          INSERT INTO im_item_ledger
                      (close_yyyymm,
                       receipt_issue_sequence,
                       organization_id,
                       material_mfs,
                       mfs,
                       item_code,
                       line_type,
                       last_inventory_qty,
                       last_avg_price,
                       last_inventory_amt,
                       receipt_account,
                       receipt_deficit,
                       receipt_date,
                       receipt_qty,
                       receipt_price,
                       receipt_amt,
                       issue_account,
                       issue_date,
                       issue_deficit,
                       issue_qty,
                       issue_price,
                       issue_amt,
                       inventory_qty,
                       material_cost,
                       material_cost_amt,
                       supplier_code,
                       workstage_code,
                       currency,
                       enter_by,
                       enter_date,
                       last_modify_by,
                       last_modify_date
                      )
               VALUES (TO_CHAR (:OLD.receipt_date, 'YYYYMM'),
                       seq_mat_ledger_sequence.NEXTVAL,
                       :OLD.organization_id,
                       :OLD.material_mfs,
                       :OLD.mfs,
                       :OLD.item_code,
                       :OLD.line_type,
                       lvf_last_inventory_qty,
                       lvf_last_avg_price,
                       lvf_last_inventory_amt,
                       '', --RECEIPT_ACCOUNT,
                       :OLD.receipt_deficit,
                       :OLD.receipt_date,
                       :OLD.receipt_qty,
                       :OLD.unit_price,
                       :OLD.receipt_amt,
                       '', --ISSUE_ACCOUNT,
                       NULL, --ISSUE_DATE,
                       '', --ISSUE_DEFICIT,
                       0, -- ISSUE_QTY,
                       0, -- ISSUE_PRICE,
                       0, -- ISSUE_AMT,
                         lvf_last_inventory_qty
                       + :OLD.receipt_qty, -- INVENTORY_QTY,
                       :OLD.material_cost,
                       :OLD.material_cost_amt,
                       :OLD.supplier_code,
                       '', -- WORKSTAGE_CODE,
                       :OLD.currency,
                       :OLD.enter_by,
                       :OLD.enter_date,
                       :OLD.last_modify_by,
                       :OLD.last_modify_date
                      );


    ----------------------------------------------------
    -- ARRIVAL STATUS CHANGE
    ----------------------------------------------------
          IF :OLD.line_type <> ' T'
          THEN
             IF :OLD.receipt_status = 'C'
             THEN
                UPDATE im_item_arrival
                   SET arrival_type = 'A',
                       receipt_date = NULL,
                       receipt_sequence = NULL
                 WHERE arrival_date = :OLD.arrival_date
                   AND arrival_seq_no = :OLD.arrival_seq_no
                   AND organization_id = :OLD.organization_id;
             ELSE
                UPDATE im_item_arrival
                   SET arrival_type = 'R',
                       receipt_date = :OLD.receipt_date,
                       receipt_sequence = :OLD.receipt_sequence
                 WHERE arrival_date = :OLD.arrival_date
                   AND arrival_seq_no = :OLD.arrival_seq_no
                   AND organization_id = :OLD.organization_id;
             END IF;

    ----------------------------------------------------
    -- ASSEMBLY ACTUAL STATUS CHANGE
    ----------------------------------------------------
          ELSE
             IF :OLD.receipt_status = 'C'
             THEN
                UPDATE ip_assembly_result
                   SET receipt_yn = 'N',
                       receipt_date = NULL,
                       receipt_sequence = NULL
                 WHERE product_date = :OLD.arrival_date
                   AND product_sequence = :OLD.arrival_seq_no
                   AND organization_id = :OLD.organization_id;
             ELSE
                UPDATE ip_assembly_result
                   SET receipt_yn = 'Y',
                       receipt_date = :OLD.receipt_date,
                       receipt_sequence = :OLD.receipt_sequence
                 WHERE product_date = :OLD.arrival_date
                   AND product_sequence = :OLD.arrival_seq_no
                   AND organization_id = :OLD.organization_id;
             END IF;
          END IF;*/

    --   NULL;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;
