CREATE OR REPLACE PROCEDURE P_PRODUCT_RESULT_WIP (
   p_product_date     IN  DATE,      -- IP_PRODUCT_RESULT 키
   p_product_sequence IN  NUMBER,
   p_organization_id  IN  NUMBER,
   p_sign             IN  NUMBER,    -- 1 = 반영(완료), -1 = 되돌림(완료 실적 취소)
   p_result           OUT VARCHAR2   -- 'OK' 반영함 / 'SKIP:<이유>' 반영 대상 아님
)
  /* ================================================================
   * 프로시저명 : P_PRODUCT_RESULT_WIP
   * 작성일     : 2026-10-19
   * 수정이력:
   *   2026-10-19 - AI(Claude) - 완제품 실적(IP_PRODUCT_RESULT)으로 제품 공정입고 + 반제품·자재 소모
   * ================================================================
   * 기능 설명:
   *   완제품 실적 한 건으로 공정재고를 움직인다 (설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md 5-7).
   *   - 제품 공정입고: 실적 품목 × 실적 수량 (IM_ITEM_WORKSTAGE_RECEIPT, ENTER_BY = 'PROD_RT', 공정 '*')
   *   - 소모: 제품 BOM 으로 반제품·자재 공정출고 (IM_ITEM_WORKSTAGE_ISSUE, ENTER_BY = 'PROD_RT').
   *     소요 규칙은 P_WIP_ISSUE_CREATE 와 같다 —
   *       직속(D): 모델 분류 RAW 이면서 SMT 런카드(면 T/B)가 있는 제품이거나, 제품 BOM 에 면(T/B/*) 표시된
   *                반제품이 있는 제품. 직속 자품목을 빼고, AOI 생산 반제품은 그 반제품을 뺀다(펼치지 않음).
   *                AOI 로 만들지 않는 반제품은 한 단계씩 더 펼친다. RAW 는 제품 하나를 뺀다. 오늘 유효 BOM.
   *       말단(L): 그 밖의 제품. BOM 말단 자재까지 펼쳐 단위 소요량을 곱한다.
   *     반제품은 지금 있는 공정(후공정 우선, 수량 많은 곳, 없으면 W180)에서, 그 밖은 '*' 에서 뺀다.
   *   - 되돌림(p_sign = -1): 같은 수량을 음수로 넣는다 (입고 구분 2, 출고 구분 4).
   *   - 일자 = 실적 PRODUCT_DATE. 공정 재고마감된 기간이면 마감 다음 날.
   *   - 인팩 전송용(IM_ITEM_WS_INV_INFAC)은 움직이지 않는다 — 예전처럼 제품창고 입고 때 P_WIP_ISSUE_CREATE 가 뺀다.
   *
   * 반영 대상 (아니면 'SKIP:' 으로 돌려주고 아무것도 넣지 않는다):
   *   - ISYS_CONFIG WIP_RESULT_CONSUME_FROM 이 있고 실적 시각(PRODUCT_ACTUAL_TIME)이 그 뒤
   *   - 작업구분(WORK_DIVISION) 'P' 생산 — 조립라인 실적. 가공(W)·수리(R) 실적은 실적만 남긴다.
   *   - 모델 DANA-LPS-680pF 제외 (P_WIP_ISSUE_CREATE 와 같다)
   *
   * 반영 여부는 호출한 쪽이 IP_PRODUCT_RESULT.WORKSTAGE_ISSUE_YN 에 남긴다. COMMIT 도 호출한 쪽이 한다.
   * 오류가 나면 이 프로시저가 한 일만 되돌리고 다시 던진다.
   * ================================================================ */
IS
   v_from     DATE;
   v_direct   DATE;
   v_item     ip_product_result.item_code%TYPE;
   v_qty      NUMBER;
   v_div      ip_product_result.work_division%TYPE;
   v_time     DATE;
   v_date     DATE;
   v_model    VARCHAR2(100);
   v_closed   DATE;
BEGIN
   SAVEPOINT sp_product_result_wip;
   p_result := 'OK';

   SELECT MAX(TO_DATE(CONFIG_VALUE, 'YYYY/MM/DD HH24:MI:SS')) INTO v_from
     FROM ISYS_CONFIG
    WHERE CONFIG_NAME = 'WIP_RESULT_CONSUME_FROM' AND ORGANIZATION_ID = 1 AND NVL(USE_YN, 'Y') = 'Y';
   SELECT MAX(TO_DATE(CONFIG_VALUE, 'YYYY/MM/DD HH24:MI:SS')) INTO v_direct
     FROM ISYS_CONFIG
    WHERE CONFIG_NAME = 'WIP_DIRECT_CONSUME_FROM' AND ORGANIZATION_ID = 1 AND NVL(USE_YN, 'Y') = 'Y';

   SELECT r.item_code, r.product_actual_qty, r.work_division, NVL(r.product_actual_time, r.enter_date), TRUNC(r.product_date)
     INTO v_item, v_qty, v_div, v_time, v_date
     FROM ip_product_result r
    WHERE r.product_date = p_product_date AND r.product_sequence = p_product_sequence
      AND r.organization_id = p_organization_id;

   IF v_from IS NULL OR v_time < v_from THEN
      p_result := 'SKIP:전환 전 실적';
      RETURN;
   END IF;
   IF NVL(v_div, '*') <> 'P' THEN
      p_result := 'SKIP:생산(조립) 실적 아님';
      RETURN;
   END IF;
   IF NVL(v_qty, 0) = 0 THEN
      p_result := 'SKIP:수량 0';
      RETURN;
   END IF;

   SELECT MAX(m.model_name) INTO v_model
     FROM ip_product_model_master m
    WHERE m.item_code = v_item AND m.organization_id = p_organization_id;
   IF v_model = 'DANA-LPS-680pF' THEN
      p_result := 'SKIP:제외 모델';
      RETURN;
   END IF;

   v_closed := pkg_inv_close_lock.closed_through('WIP', p_organization_id);
   v_date := GREATEST(v_date, NVL(v_closed + 1, v_date));

   -- 제품 공정입고
   INSERT INTO im_item_workstage_receipt (receipt_date, receipt_sequence, organization_id, item_code, receipt_deficit, receipt_qty,
                                          enter_date, enter_by, last_modify_date, last_modify_by, workstage_code)
   VALUES (v_date, seq_workstage_receipt_seq.NEXTVAL, p_organization_id, v_item,
           CASE WHEN p_sign < 0 THEN '2' ELSE '1' END, p_sign * v_qty,
           SYSDATE, 'PROD_RT', SYSDATE, SUBSTR(v_item, 1, 20), '*');

   -- 반제품·자재 소모
   INSERT INTO im_item_workstage_issue (issue_date, issue_sequence, organization_id, item_code, issue_deficit, issue_qty,
                                        enter_date, enter_by, last_modify_date, last_modify_by, workstage_code)
   SELECT v_date, seq_workstage_issue_seq.NEXTVAL, p_organization_id, x.item_code,
          CASE WHEN x.qty < 0 THEN '4' ELSE '3' END, x.qty,
          SYSDATE, 'PROD_RT', SYSDATE, SUBSTR(v_item, 1, 20), x.ws
     FROM (
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
           SELECT c.item_code, p_sign * v_qty * c.qty AS qty,
                  CASE WHEN c.semi_yn = 'Y' THEN NVL(sl.ws, 'W180') ELSE '*' END AS ws
             FROM cons c
             LEFT JOIN semloc sl ON sl.item_code = c.item_code
            WHERE v_qty * c.qty <> 0
          ) x;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK TO sp_product_result_wip;
      RAISE;
END P_PRODUCT_RESULT_WIP;
