CREATE OR REPLACE PROCEDURE P_WIP_ISSUE_CREATE (
   p_from_date IN DATE DEFAULT NULL  -- 이 날짜 이전 포장은 공정출고를 만들지 않는다 (NULL = 제한 없음)
)
  /* ================================================================
   * 프로시저명 : P_WIP_ISSUE_CREATE
   * 작성일     : 2026-10-11
   * 수정이력:
   *   2026-10-11 - AI(Claude) - 포장 실적 × BOM 으로 전 고객 공정출고 생성
   *   2026-10-12 - AI(Claude) - 포장 시점이 아니라 제품 입고 시점에 소모한다
   * ================================================================
   * 기능 설명:
   *   제품창고에 입고된 박스(IP_PRODUCT_PACK_MASTER.RECEIPT_FLAG = 'Y')의 자재를 공정재고에서 뺀다
   *   (IM_ITEM_WORKSTAGE_ISSUE, 생산투입). 입고 전 박스·반제품·미포장 제품은 모두 공정재고다.
   *   - 소모: 입고됐는데 아직 안 뺀 박스 (WIP_PROCESS_FLAG = 'N').
   *   - 되돌림: 입고취소로 RECEIPT_FLAG 가 'N' 으로 돌아왔는데 이미 뺀 박스 (WIP_PROCESS_FLAG = 'Y').
   *     같은 수량을 음수(구분 4, 출고취소)로 넣어 공정재고로 되돌리고 'N' 으로 바꾼다. 다시 입고하면 다시 뺀다.
   *     2026-10-01 이전 포장은 되돌리지 않는다 — 그때는 고객 IP 제품 × 공급사 IP 자재만 뺐거나
   *     아예 빼지 않아서, 전체 BOM 으로 되돌리면 빼지 않은 것까지 더한다.
   *   - 소요: 박스 제품의 BOM(ID_ENG_BOM, 제품별로 펼쳐진 BOM)을 말단 자재까지 내려가며 단위 소요량을
   *           곱한다. 같은 자재가 여러 경로에 있으면 더한다.
   *   - 제외: 자체 생산 반제품(그 자신이 BOM 의 제품인 품목)은 공정재고 자재가 아니라 뺀다.
   *   - 수량 = 박스 수량(PACK_QTY, 제품 입고 수량과 같다) × 누적 소요량.
   *     PACKING_PCS_QTY 는 박스 분할(P_PRODUCT_FG_INV_DEVIDE) 때 두 박스에 원래 값이 그대로 복사돼 쓰지 않는다.
   *   - 출고일 = 그 박스의 마지막 입고일(되돌림은 마지막 입고취소일). 입고 기록이 없으면(제품 실사로 찾은 박스)
   *     처리한 날. LAST_MODIFY_BY = 박스 제품 품목코드.
   *
   * 2026-10-11 까지는 포장 시점에 뺐다. 그래서 입고 안 한 박스는 공정에도 제품에도 없었다.
   * 2026-10-12 이 버전을 처음 돌리면 2026-10 포장 중 입고 안 한 박스(그때 이미 뺀 것)를 되돌림으로 공정재고에 돌려놓는다.
   *
   * 처리 표시:
   *   이번 회차 대상만 먼저 'P'(뺄 것) · 'R'(되돌릴 것)로 묶고, 출고를 만든 뒤 'Y' · 'N' 으로 바꾼다.
   *   처리 중에 새로 입고된 박스는 다음 회차로 넘어간다. 'P' · 'R' 은 같은 트랜잭션 안에서만 존재한다.
   *   오류가 나면 이 프로시저가 한 일만 되돌리고 다시 던진다. COMMIT 은 호출한 쪽이 한다.
   *
   * 마감된 기간:
   *   출고일이 이미 공정 재고마감된 기간이면 마감 다음 날(열린 기간 첫날)로 넣는다.
   *   마감 잠금 트리거(TRG_IM_WS_ISSUE_LOCK)가 마감 기간 출고를 거절하므로, 그대로 넣으면 한 건 때문에
   *   잡 전체가 실패하고 그 뒤 생산투입이 계속 멈춘다.
   * ================================================================ */
IS
   c_full_from CONSTANT DATE := DATE '2026-10-01';  -- 전체 BOM 으로 빼기 시작한 포장일
BEGIN
   SAVEPOINT sp_wip_issue_create;

   UPDATE ip_product_pack_master
      SET wip_process_flag = 'P'
    WHERE receipt_flag = 'Y'
      AND NVL (wip_process_flag, 'N') = 'N';

   UPDATE ip_product_pack_master
      SET wip_process_flag = 'R'
    WHERE NVL (receipt_flag, 'N') = 'N'
      AND wip_process_flag = 'Y'
      AND pack_date >= c_full_from;

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
   SELECT GREATEST(x.txn_date, NVL(x.closed_through + 1, x.txn_date)),
          seq_workstage_issue_seq.NEXTVAL,
          x.organization_id,
          x.item_code,
          CASE WHEN x.issue_qty < 0 THEN '4' ELSE '3' END,  -- 체크 제약: 3 은 0 이상, 4(출고취소)는 0 이하
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
           SELECT NVL ((SELECT TRUNC (MAX (r.receipt_date))
                          FROM ip_product_fg_receipt r
                         WHERE r.barcode = p.pack_barcode
                           AND r.txn_deficit = DECODE (p.wip_process_flag, 'P', '1', '2')),
                       TRUNC (SYSDATE)) AS txn_date,
                  p.organization_id, l.child AS item_code,
                  (SELECT pkg_inv_close_lock.closed_through('WIP', p.organization_id) FROM dual) AS closed_through,
                  DECODE (p.wip_process_flag, 'P', 1, -1) * p.pack_qty * l.qty AS issue_qty, p.part_no
             FROM ip_product_pack_master p
             JOIN leaf l
               ON l.top_item = p.part_no
              AND l.org = p.organization_id
            WHERE p.wip_process_flag IN ('P', 'R')
              AND p.model_name NOT IN ('DANA-LPS-680pF')
              AND p.pack_date >= NVL (p_from_date, DATE '1900-01-01')
              AND p.pack_qty * l.qty <> 0
          ) x;

   UPDATE ip_product_pack_master
      SET wip_process_flag = DECODE (wip_process_flag, 'P', 'Y', 'N'),
          wip_process_date = SYSDATE
    WHERE wip_process_flag IN ('P', 'R');
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK TO sp_wip_issue_create;
      RAISE;
END P_WIP_ISSUE_CREATE;
/
