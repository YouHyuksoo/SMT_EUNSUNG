CREATE OR REPLACE PROCEDURE P_WIP_MOVE_BY_MAGAZINE (
   p_label       IN  VARCHAR2,   -- 매거진 라벨 번호 (공정 IO SERIAL_NO)
   p_to_ws       IN  VARCHAR2,   -- 도착 공정 (스캔한 후공정)
   p_qty         IN  NUMBER,     -- 이동 수량 (스캔 수량, 없으면 매거진 장입 수량)
   p_time        IN  DATE,       -- 이동 시각 (스캔 시각)
   p_line_code   IN  VARCHAR2,
   p_io_date     IN  DATE,       -- 공정 IO 키 (기록용)
   p_io_sequence IN  NUMBER,
   p_user        IN  VARCHAR2,
   p_result      OUT VARCHAR2    -- 'OK' 또는 건너뛴 이유
)
  /* ================================================================
   * 프로시저명 : P_WIP_MOVE_BY_MAGAZINE
   * 작성일     : 2026-10-18
   * 수정이력:
   *   2026-10-18 - AI(Claude) - 후공정 매거진 스캔으로 반제품 공정재고를 공정간 이동한다
   * ================================================================
   * 기능 설명:
   *   설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md (5-5)
   *   - 매거진: IP_PRODUCT_RUN_CARD_IO.MAGAZINE_LABEL_NO = p_label. SMT(W180)에서 발행한 라벨.
   *   - 품목: 매거진 런카드의 반제품 (F_GET_ASSY_SEMI_ITEM — AOI 실적과 같은 BOM 규칙).
   *   - 출발 공정: 이 매거진이 마지막으로 도착한 공정 (IM_ITEM_WS_MOVE), 처음이면 W180.
   *   - 공정출고(출발, 구분 3) + 공정입고(도착, 구분 1), ENTER_BY = 'WS_MOVE', LAST_MODIFY_BY = 라벨.
   *     품목 합계로는 0 이라 품목 현재고·재고마감·인팩 전송은 변하지 않는다.
   *   - 같은 라벨·도착 공정은 한 번만 (IM_ITEM_WS_MOVE PK). 출발 = 도착이면 건너뛴다.
   *   - 전환(ISYS_CONFIG WIP_DIRECT_CONSUME_FROM) 전에 발행한 매거진은 W180 에 반제품 입고가 없어 옮기지 않는다.
   *   - COMMIT 하지 않는다.
   * ================================================================ */
IS
   c_smt_ws  CONSTANT VARCHAR2(10) := 'W180';
   v_run     VARCHAR2(30);
   v_issued  DATE;
   v_lot     NUMBER;
   v_item    VARCHAR2(30);
   v_from_ws VARCHAR2(20);
   v_cutover VARCHAR2(30);
   v_qty     NUMBER;
   v_time    DATE := NVL(p_time, SYSDATE);
   v_cnt     NUMBER;
BEGIN
   p_result := 'OK';
   IF p_label IS NULL OR p_to_ws IS NULL THEN p_result := '라벨 또는 공정 없음'; RETURN; END IF;
   IF p_to_ws = c_smt_ws THEN p_result := 'SMT 공정 스캔'; RETURN; END IF;

   BEGIN
      SELECT RUN_NO, RECEIPT_DATE, LOT_QTY INTO v_run, v_issued, v_lot
        FROM (SELECT RUN_NO, RECEIPT_DATE, LOT_QTY FROM IP_PRODUCT_RUN_CARD_IO
               WHERE MAGAZINE_LABEL_NO = p_label AND ORGANIZATION_ID = 1
               ORDER BY RECEIPT_DATE DESC)
       WHERE ROWNUM = 1;
   EXCEPTION WHEN NO_DATA_FOUND THEN p_result := '매거진 라벨 아님 ' || p_label; RETURN;
   END;

   SELECT MAX(CONFIG_VALUE) INTO v_cutover FROM ISYS_CONFIG
    WHERE CONFIG_NAME = 'WIP_DIRECT_CONSUME_FROM' AND ORGANIZATION_ID = 1 AND NVL(USE_YN, 'Y') = 'Y';
   IF v_cutover IS NULL OR TO_CHAR(v_issued, 'YYYY/MM/DD HH24:MI:SS') < v_cutover THEN
      p_result := '전환 전 매거진'; RETURN;
   END IF;

   SELECT COUNT(*) INTO v_cnt FROM IM_ITEM_WS_MOVE
    WHERE MAGAZINE_LABEL_NO = p_label AND TO_WORKSTAGE_CODE = p_to_ws AND ORGANIZATION_ID = 1;
   IF v_cnt > 0 THEN p_result := '이미 이동'; RETURN; END IF;

   v_item := F_GET_ASSY_SEMI_ITEM(v_run);
   IF v_item IS NULL THEN p_result := '반제품 없음 ' || v_run; RETURN; END IF;

   SELECT NVL(MAX(TO_WORKSTAGE_CODE) KEEP (DENSE_RANK LAST ORDER BY MOVE_DATE, ENTER_DATE), c_smt_ws) INTO v_from_ws
     FROM IM_ITEM_WS_MOVE WHERE MAGAZINE_LABEL_NO = p_label AND ORGANIZATION_ID = 1;
   IF v_from_ws = p_to_ws THEN p_result := '같은 공정'; RETURN; END IF;

   v_qty := NVL(NULLIF(p_qty, 0), v_lot);
   IF NVL(v_qty, 0) <= 0 THEN p_result := '수량 없음'; RETURN; END IF;

   INSERT INTO IM_ITEM_WORKSTAGE_ISSUE (ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, ISSUE_DEFICIT, ISSUE_QTY,
                                        ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, WORKSTAGE_CODE)
   VALUES (v_time, SEQ_WORKSTAGE_ISSUE_SEQ.NEXTVAL, 1, v_item, '3', v_qty, SYSDATE, 'WS_MOVE', SYSDATE, SUBSTR(p_label, 1, 20), v_from_ws);
   INSERT INTO IM_ITEM_WORKSTAGE_RECEIPT (RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, RECEIPT_DEFICIT, RECEIPT_QTY,
                                          ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, WORKSTAGE_CODE)
   VALUES (v_time, SEQ_WORKSTAGE_RECEIPT_SEQ.NEXTVAL, 1, v_item, '1', v_qty, SYSDATE, 'WS_MOVE', SYSDATE, SUBSTR(p_label, 1, 20), p_to_ws);
   INSERT INTO IM_ITEM_WS_MOVE (MAGAZINE_LABEL_NO, TO_WORKSTAGE_CODE, ORGANIZATION_ID, FROM_WORKSTAGE_CODE, ITEM_CODE, MOVE_QTY,
                                MOVE_DATE, RUN_NO, LINE_CODE, IO_DATE, IO_SEQUENCE, ENTER_DATE, ENTER_BY)
   VALUES (p_label, p_to_ws, 1, v_from_ws, v_item, v_qty, v_time, v_run, p_line_code, p_io_date, p_io_sequence,
           SYSDATE, SUBSTR(NVL(p_user, 'WS_MOVE'), 1, 20));
END P_WIP_MOVE_BY_MAGAZINE;
/
