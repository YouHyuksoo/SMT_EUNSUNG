CREATE OR REPLACE PROCEDURE P_ROUTING_RESULT_WIP (
   p_product_date     IN  DATE,      -- IP_PRODUCT_RESULT 키
   p_product_sequence IN  NUMBER,
   p_organization_id  IN  NUMBER,
   p_sign             IN  NUMBER,    -- 1 = 반영(완료), -1 = 되돌림(완료 실적 취소)
   p_result           OUT VARCHAR2   -- 'OK' 이동함 / 'SKIP:<이유>' 이동 대상 아님
)
  /* ================================================================
   * 프로시저명 : P_ROUTING_RESULT_WIP
   * 작성일     : 2026-11-05
   * 수정이력:
   *   2026-11-05 - AI(Claude) - 공정 실적이 생기면 반제품 재공을 라우팅 공정 순서대로 옮긴다 (재공수불 경로)
   * ================================================================
   * 기능 설명:
   *   실적이 발생한 공정에 재공이 생기고, 다음 공정에서 실적이 발생하면 이전 공정의 재공이 줄어든다.
   *   검사 공정(ICT 등)도 같다. 자재는 차감하지 않는다 — 소모는 포장 완제품 실적(P_PRODUCT_RESULT_WIP)에서 BOM 으로 한다.
   *   - 대상 재공: 그 실적 품목의 반제품(P_PRODUCT_RESULT_WIP 와 같은 규칙: AOI 생산 반제품, 원자재만 제품은 제품 자신)
   *     × BOM 소요량 × 실적수량. 원자재·AOI 가 만들지 않는 반제품은 옮기지 않는다.
   *   - 이동: 출발 공정 출고 + 도착(실적 공정) 입고 한 쌍. ENTER_BY = 'WS_MOVE' (P_WIP_MOVE_BY_MAGAZINE 과 같은 표시).
   *     품목 합계로는 0 이라 재고 합계·마감·원장·인팩 전송 장부에 영향이 없다 (공정별 수량은 IM_ITEM_WORKSTAGE_INV_WS).
   *   - 출발 공정: 라우팅에서 이 공정 바로 앞 공정. 첫 공정이면 반제품이 지금 있는 공정(후공정 우선, 수량 많은 곳, 없으면 W180).
   *     출발 = 도착이면 옮기지 않는다.
   *   - 포장(작업구분 P) 실적은 옮기지 않는다 — 포장 BOM 차감이 반제품이 있는 공정에서 뺀다.
   *   - 같은 실적을 두 번 옮기지 않는다: 실적 키(LAST_MODIFY_BY = 'RW:<일자>:<순번>') 가 달린 입고 행의 순합계가 0 이 아니면 SKIP.
   *   - 되돌림(p_sign = -1): 그 실적 키가 달린 입출고 행을 같은 수량 음수로 넣는다(입고 구분 2, 출고 구분 4). 옮긴 만큼만 되돌린다.
   *   - 일자 = 실적 PRODUCT_DATE. 공정 재고마감된 기간이면 마감 다음 날.
   *
   * 이동 대상 (아니면 'SKIP:' 으로 돌려주고 아무것도 넣지 않는다):
   *   - ISYS_CONFIG WIP_RESULT_CONSUME_FROM 이 있고 실적 시각이 그 뒤 (되돌림은 확인하지 않는다)
   *   - 수량 0 아님, 작업구분 P(포장)·R(수리) 아님, 품목에 라우팅이 있고 실적 공정이 그 라우팅 공정, 모델 DANA-LPS-680pF 아님
   *
   * 이동 여부는 호출한 쪽이 IP_PRODUCT_RESULT.WORKSTAGE_ISSUE_YN 에 남긴다. COMMIT 도 호출한 쪽이 한다.
   * 오류가 나면 이 프로시저가 한 일만 되돌리고 다시 던진다.
   * ================================================================ */
IS
   v_from     DATE;
   v_direct   DATE;
   v_item     ip_product_result.item_code%TYPE;
   v_qty      NUMBER;
   v_div      ip_product_result.work_division%TYPE;
   v_ws       ip_product_result.workstage_code%TYPE;
   v_time     DATE;
   v_date     DATE;
   v_closed   DATE;
   v_model    VARCHAR2(100);
   v_routing  id_item.routing_code%TYPE;
   v_seq      NUMBER;
   v_prev     VARCHAR2(20);
   v_tag      VARCHAR2(20);
   v_net      NUMBER;
   v_moved    NUMBER := 0;
BEGIN
   SAVEPOINT sp_routing_result_wip;
   p_result := 'OK';

   SELECT r.item_code, r.product_actual_qty, r.work_division, r.workstage_code, NVL(r.product_actual_time, r.enter_date), TRUNC(r.product_date)
     INTO v_item, v_qty, v_div, v_ws, v_time, v_date
     FROM ip_product_result r
    WHERE r.product_date = p_product_date AND r.product_sequence = p_product_sequence
      AND r.organization_id = p_organization_id;

   v_tag := 'RW:' || TO_CHAR(p_product_date, 'YYMMDD') || ':' || p_product_sequence;
   v_closed := pkg_inv_close_lock.closed_through('WIP', p_organization_id);
   v_date := GREATEST(v_date, NVL(v_closed + 1, v_date));

   IF p_sign < 0 THEN
      -- 되돌림: 이 실적으로 옮긴 만큼만 음수로 넣는다 (출발 입고 · 도착 출고가 그대로 뒤집힌다)
      INSERT INTO im_item_workstage_receipt (receipt_date, receipt_sequence, organization_id, item_code, receipt_deficit, receipt_qty,
                                             enter_date, enter_by, last_modify_date, last_modify_by, workstage_code)
      SELECT v_date, seq_workstage_receipt_seq.NEXTVAL, p_organization_id, x.item_code,
             CASE WHEN x.net > 0 THEN '2' ELSE '1' END, -x.net, SYSDATE, 'WS_MOVE', SYSDATE, v_tag, x.workstage_code
        FROM (SELECT item_code, workstage_code, SUM(receipt_qty) AS net
                FROM im_item_workstage_receipt
               WHERE last_modify_by = v_tag AND enter_by = 'WS_MOVE' AND organization_id = p_organization_id
               GROUP BY item_code, workstage_code
              HAVING SUM(receipt_qty) <> 0) x;
      v_moved := SQL%ROWCOUNT;
      INSERT INTO im_item_workstage_issue (issue_date, issue_sequence, organization_id, item_code, issue_deficit, issue_qty,
                                           enter_date, enter_by, last_modify_date, last_modify_by, workstage_code)
      SELECT v_date, seq_workstage_issue_seq.NEXTVAL, p_organization_id, x.item_code,
             CASE WHEN x.net > 0 THEN '4' ELSE '3' END, -x.net, SYSDATE, 'WS_MOVE', SYSDATE, v_tag, x.workstage_code
        FROM (SELECT item_code, workstage_code, SUM(issue_qty) AS net
                FROM im_item_workstage_issue
               WHERE last_modify_by = v_tag AND enter_by = 'WS_MOVE' AND organization_id = p_organization_id
               GROUP BY item_code, workstage_code
              HAVING SUM(issue_qty) <> 0) x;
      v_moved := v_moved + SQL%ROWCOUNT;
      IF v_moved = 0 THEN
         p_result := 'SKIP:되돌릴 공정 재공 이동 없음';
      END IF;
      RETURN;
   END IF;

   SELECT MAX(TO_DATE(CONFIG_VALUE, 'YYYY/MM/DD HH24:MI:SS')) INTO v_from
     FROM ISYS_CONFIG
    WHERE CONFIG_NAME = 'WIP_RESULT_CONSUME_FROM' AND ORGANIZATION_ID = 1 AND NVL(USE_YN, 'Y') = 'Y';
   SELECT MAX(TO_DATE(CONFIG_VALUE, 'YYYY/MM/DD HH24:MI:SS')) INTO v_direct
     FROM ISYS_CONFIG
    WHERE CONFIG_NAME = 'WIP_DIRECT_CONSUME_FROM' AND ORGANIZATION_ID = 1 AND NVL(USE_YN, 'Y') = 'Y';
   IF v_from IS NULL OR v_time < v_from THEN
      p_result := 'SKIP:전환 전 실적';
      RETURN;
   END IF;
   IF NVL(v_qty, 0) = 0 THEN
      p_result := 'SKIP:수량 0';
      RETURN;
   END IF;
   IF NVL(v_div, '*') IN ('P', 'R') THEN
      p_result := 'SKIP:포장·수리 실적은 옮기지 않음';
      RETURN;
   END IF;

   SELECT MAX(m.model_name) INTO v_model
     FROM ip_product_model_master m
    WHERE m.item_code = v_item AND m.organization_id = p_organization_id;
   IF v_model = 'DANA-LPS-680pF' THEN
      p_result := 'SKIP:제외 모델';
      RETURN;
   END IF;

   SELECT MAX(i.routing_code) INTO v_routing
     FROM id_item i WHERE i.item_code = v_item AND i.organization_id = p_organization_id;
   IF v_routing IS NULL THEN
      p_result := 'SKIP:품목에 라우팅 없음';
      RETURN;
   END IF;

   SELECT MIN(p.process_seq) INTO v_seq
     FROM ip_routing_processes p
    WHERE p.organization_id = p_organization_id AND p.routing_code = v_routing AND p.workstage_code = v_ws AND p.use_yn = 'Y';
   IF v_seq IS NULL THEN
      p_result := 'SKIP:실적 공정이 라우팅에 없음';
      RETURN;
   END IF;

   SELECT NVL(SUM(receipt_qty), 0) INTO v_net
     FROM im_item_workstage_receipt
    WHERE last_modify_by = v_tag AND enter_by = 'WS_MOVE' AND organization_id = p_organization_id;
   IF v_net <> 0 THEN
      p_result := 'SKIP:이미 이동한 실적';
      RETURN;
   END IF;

   -- 바로 앞 공정 (없으면 첫 공정)
   SELECT MAX(p.workstage_code) KEEP (DENSE_RANK LAST ORDER BY p.process_seq) INTO v_prev
     FROM ip_routing_processes p
    WHERE p.organization_id = p_organization_id AND p.routing_code = v_routing AND p.use_yn = 'Y' AND p.process_seq < v_seq;

   FOR m IN (
      WITH top AS (
                    SELECT v_item AS top, p_organization_id AS org,
                           CASE WHEN m.bom_explode_type = 'RAW' THEN 'Y' ELSE 'N' END AS raw_yn,
                           CASE WHEN v_direct IS NOT NULL AND v_time >= v_direct
                                 AND ((m.bom_explode_type = 'RAW' AND EXISTS (SELECT 1 FROM ip_product_run_card rc
                                                  WHERE rc.item_code = v_item AND rc.organization_id = p_organization_id
                                                    AND rc.pcb_item IN ('T', 'B')))
                                      OR EXISTS (SELECT 1 FROM id_eng_bom b
                                                  WHERE b.item_code = v_item AND b.organization_id = p_organization_id
                                                    AND b.parent_item_code <> '*' AND b.pcb_item IN ('T', 'B', '*')
                                                    AND b.child_item_code <> b.parent_item_code
                                                    AND EXISTS (SELECT 1 FROM id_eng_bom k
                                                                 WHERE k.item_code = v_item AND k.parent_item_code = b.child_item_code
                                                                   AND k.organization_id = p_organization_id
                                                                   AND k.child_item_code <> k.parent_item_code)))
                                THEN 'D' ELSE 'L' END AS rule
                      FROM dual
                      LEFT JOIN ip_product_model_master m ON m.model_name = v_model AND m.organization_id = p_organization_id
                 ),
                 -- 말단 규칙 (P_WIP_ISSUE_CREATE tree/leaf 와 같다)
                 tree (child, qty) AS (
                    SELECT b.child_item_code, b.item_unit_qty
                      FROM id_eng_bom b, top t
                     WHERE b.item_code = t.top AND b.parent_item_code = b.item_code AND b.organization_id = t.org AND t.rule = 'L'
                    UNION ALL
                    SELECT b.child_item_code, tr.qty * b.item_unit_qty
                      FROM tree tr
                      JOIN id_eng_bom b
                        ON b.item_code = v_item AND b.parent_item_code = tr.child AND b.organization_id = p_organization_id
                       AND b.child_item_code <> b.parent_item_code
                 ),
                 leaf AS (
                    SELECT tr.child, SUM(tr.qty) AS qty
                      FROM tree tr
                     WHERE NOT EXISTS (SELECT 1 FROM id_eng_bom s
                                        WHERE s.item_code = v_item AND s.parent_item_code = tr.child AND s.organization_id = p_organization_id)
                       AND NOT EXISTS (SELECT 1 FROM id_eng_bom m
                                        WHERE m.item_code = tr.child AND m.organization_id = p_organization_id)
                     GROUP BY tr.child
                 ),
                 -- AOI 생산 반제품: 제품 BOM 에서 면(T/B/* 양면) 표시가 있고 자식이 있는 반제품
                 dsemi AS (
                    SELECT DISTINCT b.child_item_code AS c
                      FROM top t
                      JOIN id_eng_bom b
                        ON b.item_code = t.top AND b.organization_id = t.org AND b.parent_item_code <> '*'
                       AND b.pcb_item IN ('T', 'B', '*') AND b.child_item_code <> b.parent_item_code
                     WHERE t.rule = 'D'
                       AND EXISTS (SELECT 1 FROM id_eng_bom k
                                    WHERE k.item_code = t.top AND k.parent_item_code = b.child_item_code
                                      AND k.organization_id = t.org AND k.child_item_code <> k.parent_item_code)
                 ),
                 -- 직속 규칙: AOI 로 만들지 않는 반제품만 펼친다 (오늘 유효 BOM)
                 dtree (child, qty) AS (
                    SELECT b.child_item_code, b.item_unit_qty
                      FROM top t
                      JOIN id_eng_bom b
                        ON b.item_code = t.top AND b.parent_item_code = t.top AND b.organization_id = t.org
                       AND b.child_item_code <> b.parent_item_code
                       AND NVL(b.dateset, DATE '1900-01-01') <= SYSDATE AND NVL(b.dateend, DATE '9999-12-31') >= TRUNC(SYSDATE)
                     WHERE t.rule = 'D' AND t.raw_yn = 'N'
                    UNION ALL
                    SELECT b.child_item_code, dt.qty * b.item_unit_qty
                      FROM dtree dt
                      JOIN id_eng_bom b
                        ON b.item_code = v_item AND b.parent_item_code = dt.child AND b.organization_id = p_organization_id
                       AND b.child_item_code <> b.parent_item_code
                       AND NVL(b.dateset, DATE '1900-01-01') <= SYSDATE AND NVL(b.dateend, DATE '9999-12-31') >= TRUNC(SYSDATE)
                     WHERE NOT EXISTS (SELECT 1 FROM dsemi s WHERE s.c = dt.child)
                 ),
                 cons AS (
                    SELECT l.child AS item_code, l.qty, 'N' AS semi_yn FROM leaf l
                    UNION ALL
                    SELECT dt.child, SUM(dt.qty),
                           CASE WHEN EXISTS (SELECT 1 FROM dsemi s WHERE s.c = dt.child) THEN 'Y' ELSE 'N' END
                      FROM dtree dt
                     WHERE EXISTS (SELECT 1 FROM dsemi s WHERE s.c = dt.child)
                        OR (NOT EXISTS (SELECT 1 FROM id_eng_bom s
                                         WHERE s.item_code = v_item AND s.parent_item_code = dt.child
                                           AND s.organization_id = p_organization_id AND s.child_item_code <> s.parent_item_code)
                            AND NOT EXISTS (SELECT 1 FROM id_eng_bom m
                                             WHERE m.item_code = dt.child AND m.organization_id = p_organization_id))
                     GROUP BY dt.child
                    UNION ALL
                    -- 원자재만(모델 분류 RAW): 제품 자신이 AOI 생산 품목이면 제품 하나를 뺀다
                    SELECT t.top, 1, 'Y' FROM top t WHERE t.rule = 'D' AND t.raw_yn = 'Y'
                 ),
                 -- 반제품이 지금 있는 공정: 후공정(W180 아님) 우선, 그 안에서 수량 많은 곳. 없으면 W180
                 semloc AS (
                    SELECT item_code,
                           MAX(workstage_code) KEEP (DENSE_RANK FIRST ORDER BY CASE WHEN workstage_code = 'W180' THEN 1 ELSE 0 END,
                                                                               inventory_qty DESC) AS ws
                      FROM im_item_workstage_inv_ws
                     WHERE workstage_code <> '*' AND inventory_qty > 0 AND organization_id = p_organization_id
                     GROUP BY item_code
                 )
           SELECT c.item_code, v_qty * c.qty AS qty, NVL(v_prev, NVL(sl.ws, 'W180')) AS from_ws
             FROM cons c
             LEFT JOIN semloc sl ON sl.item_code = c.item_code
            WHERE c.semi_yn = 'Y' AND v_qty * c.qty <> 0
   ) LOOP
      IF m.from_ws = v_ws THEN
         CONTINUE;
      END IF;
      INSERT INTO im_item_workstage_issue (issue_date, issue_sequence, organization_id, item_code, issue_deficit, issue_qty,
                                           enter_date, enter_by, last_modify_date, last_modify_by, workstage_code)
      VALUES (v_date, seq_workstage_issue_seq.NEXTVAL, p_organization_id, m.item_code, CASE WHEN m.qty < 0 THEN '4' ELSE '3' END, m.qty,
              SYSDATE, 'WS_MOVE', SYSDATE, v_tag, m.from_ws);
      INSERT INTO im_item_workstage_receipt (receipt_date, receipt_sequence, organization_id, item_code, receipt_deficit, receipt_qty,
                                             enter_date, enter_by, last_modify_date, last_modify_by, workstage_code)
      VALUES (v_date, seq_workstage_receipt_seq.NEXTVAL, p_organization_id, m.item_code, CASE WHEN m.qty < 0 THEN '2' ELSE '1' END, m.qty,
              SYSDATE, 'WS_MOVE', SYSDATE, v_tag, v_ws);
      v_moved := v_moved + 1;
   END LOOP;
   IF v_moved = 0 THEN
      p_result := 'SKIP:옮길 반제품 없음';
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK TO sp_routing_result_wip;
      RAISE;
END P_ROUTING_RESULT_WIP;
/
