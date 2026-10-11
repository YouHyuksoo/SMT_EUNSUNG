CREATE OR REPLACE PROCEDURE P_WIP_ISSUE_CREATE (
   p_from_date IN DATE DEFAULT NULL  -- 이 날짜 이전 포장은 공정출고를 만들지 않는다 (NULL = 제한 없음)
)
  /* ================================================================
   * 프로시저명 : P_WIP_ISSUE_CREATE
   * 작성일     : 2026-10-11
   * ================================================================
   * 기능 설명:
   *   포장 실적(IP_PRODUCT_PACK_MASTER)으로 공정출고(IM_ITEM_WORKSTAGE_ISSUE, 생산투입)를 만든다.
   *   - 대상: 아직 처리하지 않은 포장(WIP_PROCESS_FLAG = 'N'), 모든 고객의 제품.
   *   - 소요: 포장 제품의 BOM(ID_ENG_BOM, 제품별로 펼쳐진 BOM)을 말단 자재까지 내려가며
   *           단위 소요량을 곱한다. 같은 자재가 여러 경로에 있으면 더한다.
   *   - 제외: 자체 생산 반제품(그 자신이 BOM 의 제품인 품목)은 공정재고 자재가 아니라 뺀다.
   *   - 수량 = 포장 수량 × 누적 소요량. 출고일 = 포장일. LAST_MODIFY_BY = 포장 제품 품목코드.
   *
   * 2026-10-11 이전에는 P_JOB_INFAC_DATA_CREATE 안에서 고객 IP 제품 × 공급사 IP 자재만
   * 공정출고를 만들고, 나머지 포장은 처리 표시만 해서 다른 고객 자재의 공정재고가 줄지 않았다.
   *
   * 처리 표시:
   *   이번 회차 대상만 먼저 'P' 로 묶고, 출고를 만든 뒤 'Y' 로 바꾼다. 처리 중에 새로 들어온
   *   포장은 다음 회차로 넘어간다 (예전에는 INSERT 뒤 전체를 'Y' 로 바꿔 사이에 들어온 포장이 빠졌다).
   *   'P' 는 같은 트랜잭션 안에서만 존재한다. 오류가 나면 이 프로시저가 한 일만 되돌리고 다시 던진다.
   *   COMMIT 은 호출한 쪽이 한다.
   * ================================================================ */
IS
BEGIN
   SAVEPOINT sp_wip_issue_create;

   UPDATE ip_product_pack_master
      SET wip_process_flag = 'P'
    WHERE NVL (wip_process_flag, 'N') = 'N';

   INSERT INTO im_item_workstage_issue (
               issue_date,
               issue_sequence,
               organization_id,
               item_code,
               issue_deficit,
               issue_qty,
               enter_date,
               enter_by,
               last_modify_date,
               last_modify_by
           )
   SELECT x.pack_date,
          seq_workstage_issue_seq.NEXTVAL,
          x.organization_id,
          x.item_code,
          '3',
          x.issue_qty,
          SYSDATE,
          'ADMIN',
          SYSDATE,
          x.part_no
     FROM (
           WITH tree (top_item, child, qty, org) AS (
              SELECT b.item_code, b.child_item_code, b.item_unit_qty, b.organization_id
                FROM id_eng_bom b
               WHERE b.parent_item_code = b.item_code
              UNION ALL
              SELECT t.top_item, b.child_item_code, t.qty * b.item_unit_qty, t.org
                FROM tree t
                JOIN id_eng_bom b
                  ON b.item_code = t.top_item
                 AND b.parent_item_code = t.child
                 AND b.organization_id = t.org
                 AND b.child_item_code <> b.parent_item_code
           ),
           leaf AS (
              SELECT t.top_item, t.child, SUM (t.qty) AS qty, t.org
                FROM tree t
               WHERE NOT EXISTS (SELECT 1 FROM id_eng_bom s
                                  WHERE s.item_code = t.top_item
                                    AND s.parent_item_code = t.child
                                    AND s.organization_id = t.org)
                 AND NOT EXISTS (SELECT 1 FROM id_eng_bom m
                                  WHERE m.item_code = t.child
                                    AND m.organization_id = t.org)
               GROUP BY t.top_item, t.child, t.org
           )
           SELECT p.pack_date, p.organization_id, l.child AS item_code,
                  p.packing_pcs_qty * l.qty AS issue_qty, p.part_no
             FROM ip_product_pack_master p
             JOIN leaf l
               ON l.top_item = p.part_no
              AND l.org = p.organization_id
            WHERE p.wip_process_flag = 'P'
              AND p.model_name NOT IN ('DANA-LPS-680pF')
              AND p.pack_date >= NVL (p_from_date, DATE '1900-01-01')
              AND p.packing_pcs_qty * l.qty <> 0
          ) x;

   UPDATE ip_product_pack_master
      SET wip_process_flag = 'Y',
          wip_process_date = SYSDATE
    WHERE wip_process_flag = 'P';
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK TO sp_wip_issue_create;
      RAISE;
END P_WIP_ISSUE_CREATE;
