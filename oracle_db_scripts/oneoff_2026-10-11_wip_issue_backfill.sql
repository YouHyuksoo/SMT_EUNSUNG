-- 2026-10-11 공정출고 보정 (일회성)
-- 2026-10 마감 기간(10/01~) 포장 중, 예전 P_JOB_INFAC_DATA_CREATE 가 처리 표시만 하고
-- 공정출고를 만들지 않은 몫(고객 IP 제품 × 공급사 IP 자재가 아닌 조합)을 P_WIP_ISSUE_CREATE 와
-- 같은 규칙(BOM 말단 자재 × 누적 소요량)으로 넣는다. 고객 IP × 공급사 IP 조합은 이미 들어가 있어 건드리지 않는다.
-- 되돌리기: DELETE FROM IM_ITEM_WORKSTAGE_ISSUE WHERE ENTER_BY = 'WIPFIX20261011'
--   (삭제 트리거가 없으므로 공정재고는 IM_ITEM_WORKSTAGE_INVENTORY 에 출고 수량을 다시 더해야 한다)
INSERT INTO im_item_workstage_issue (
            issue_date, issue_sequence, organization_id, item_code, issue_deficit, issue_qty,
            enter_date, enter_by, last_modify_date, last_modify_by)
SELECT x.pack_date, seq_workstage_issue_seq.NEXTVAL, x.organization_id, x.item_code, '3', x.issue_qty,
       SYSDATE, 'WIPFIX20261011', SYSDATE, x.part_no
  FROM (
        WITH tree (top_item, child, qty, org) AS (
           SELECT b.item_code, b.child_item_code, b.item_unit_qty, b.organization_id
             FROM id_eng_bom b
            WHERE b.parent_item_code = b.item_code
           UNION ALL
           SELECT t.top_item, b.child_item_code, t.qty * b.item_unit_qty, t.org
             FROM tree t
             JOIN id_eng_bom b
               ON b.item_code = t.top_item AND b.parent_item_code = t.child AND b.organization_id = t.org
              AND b.child_item_code <> b.parent_item_code
        ),
        leaf AS (
           SELECT t.top_item, t.child, SUM (t.qty) AS qty, t.org
             FROM tree t
            WHERE NOT EXISTS (SELECT 1 FROM id_eng_bom s
                               WHERE s.item_code = t.top_item AND s.parent_item_code = t.child AND s.organization_id = t.org)
              AND NOT EXISTS (SELECT 1 FROM id_eng_bom m WHERE m.item_code = t.child AND m.organization_id = t.org)
            GROUP BY t.top_item, t.child, t.org
        )
        SELECT p.pack_date, p.organization_id, l.child AS item_code,
               p.packing_pcs_qty * l.qty AS issue_qty, p.part_no
          FROM ip_product_pack_master p
          JOIN leaf l ON l.top_item = p.part_no AND l.org = p.organization_id
          JOIN id_item ci ON ci.item_code = l.child AND ci.organization_id = l.org
         WHERE p.pack_date >= DATE '2026-10-01'
           AND p.wip_process_flag = 'Y'
           AND p.model_name NOT IN ('DANA-LPS-680pF')
           AND p.packing_pcs_qty * l.qty <> 0
           AND NOT (ci.supplier_code = 'IP'
                    AND p.part_no IN (SELECT item_code FROM ip_product_model_master WHERE customer_code = 'IP'))
       ) x
