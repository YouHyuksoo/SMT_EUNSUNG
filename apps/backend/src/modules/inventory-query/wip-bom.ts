/**
 * @file src/modules/inventory-query/wip-bom.ts
 * @description 공정재고와 제품 입고를 잇는 규칙 — 생산투입 대기 판정 · BOM 말단 전개 · 실사 중 입고된 박스
 *
 * 초보자 가이드:
 * 1. **제품창고에 입고되기 전까지는 전부 공정재고다.** 생산투입(공정출고)은 DB 잡
 *    P_WIP_ISSUE_CREATE(06:10·17:10)가 입고된 박스의 BOM 말단 자재만큼 만든다.
 *    입고취소된 박스는 같은 수량을 음수로 넣어 되돌린다 (2026-10-01 이후 포장만).
 * 2. 그래서 공정재고 장부에는 원자재만 있다. 라인의 반제품·미포장 제품·입고 안 한 박스는
 *    그 안의 원자재로 장부에 남아 있다. 실사에서 이것들을 세면 같은 BOM 규칙으로 원자재로 풀어 더한다.
 * 3. `bomLeafSql` 은 P_WIP_ISSUE_CREATE 의 tree/leaf 와 같은 규칙이다. 한쪽을 바꾸면 다른 쪽도 바꾼다.
 */
import { BadRequestException } from '@nestjs/common';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;
type Queryable = { query: (sql: string, parameters?: unknown[]) => Promise<unknown> };
const num = (v: unknown) => Number(v ?? 0);

/** 이 포장일부터 전체 BOM 으로 뺐다 (그 전 포장은 입고취소돼도 되돌리지 않는다). P_WIP_ISSUE_CREATE 의 c_full_from */
export const WIP_FULL_CONSUME_FROM = '2026-10-01';

/** 생산투입 잡이 빼지 않는 모델 (P_WIP_ISSUE_CREATE 와 같다) */
const EXCLUDED_MODELS = `('DANA-LPS-680pF')`;

/** 실사 입력에서 박스를 가리키는 롯트 칸 값. 박스 바코드는 80자까지라 롯트 칸(30자)에 그대로 못 넣는다. */
export const wipBoxKeySql = (barcodeCol: string) => `'#B' || ORA_HASH(${barcodeCol}, 4294967295)`;

/**
 * 생산투입 잡이 아직 처리하지 않은 박스 — 입고됐는데 안 뺀 것, 입고취소됐는데 이미 뺀 것.
 * P_WIP_ISSUE_CREATE 가 'P' · 'R' 로 묶는 대상과 같다.
 */
export const wipPendingPackWhere = (p = 'p') => `(
  (${p}.RECEIPT_FLAG = 'Y' AND NVL(${p}.WIP_PROCESS_FLAG, 'N') = 'N')
  OR (NVL(${p}.RECEIPT_FLAG, 'N') = 'N' AND ${p}.WIP_PROCESS_FLAG = 'Y'
      AND ${p}.PACK_DATE >= DATE '${WIP_FULL_CONSUME_FROM}'))`;

/**
 * 생산투입을 지금까지의 입고·입고취소까지 반영한다. 처리 안 된 박스가 남은 채로 장부를 고정하거나 조정하거나
 * 마감하면, 그 소모가 나중에 또 빠져 이중 차감이 된다. 입고는 하루 종일 생기므로 기다리지 않고
 * 같은 트랜잭션에서 프로시저를 돌린다 (프로시저는 COMMIT 하지 않고, 대상을 'P' · 'R' 로 묶어
 * 정기 잡과 겹쳐도 두 번 처리하지 않는다). 잡과 같은 포장일 하한(2023-07-01)을 쓴다.
 */
export async function catchUpWipIssue(q: Queryable, organizationId: number) {
  await q.query(`BEGIN P_WIP_ISSUE_CREATE(TO_DATE('20230701', 'YYYYMMDD')); END;`);
  const pending = num(((await q.query(
    `SELECT COUNT(*) AS "n" FROM IP_PRODUCT_PACK_MASTER p
      WHERE p.ORGANIZATION_ID = :organizationId AND ${wipPendingPackWhere('p')}`,
    namedBinds({ organizationId }),
  )) as Row[])[0]?.n);
  if (pending) {
    throw new BadRequestException(
      `생산투입을 반영하지 못한 박스가 ${pending.toLocaleString()}건 남았습니다. 잠시 뒤 다시 하세요.`,
    );
  }
}

/**
 * BOM 말단 전개. `src` 는 TOP_ITEM · NODE · QTY 를 돌려주는 SELECT 다.
 * NODE = TOP_ITEM 이면 그 제품 전체를, 아니면 그 제품 BOM 안의 반제품 NODE 아래만 푼다.
 * 결과는 ITEM_CODE · QTY (말단 자재별 합). 자체 생산 반제품(그 자신이 BOM 의 제품인 품목)은 말단에서 뺀다.
 * 맨 바깥 WITH 이다 (재귀 WITH 를 다른 WITH 안에 넣으면 ORA-32034). 인라인 뷰로 감싸 써도 된다.
 * `:organizationId` 바인드를 쓴다.
 */
export const bomLeafSql = (src: string) => `
  WITH bsrc AS (${src}),
  btree (top_item, child, qty) AS (
    SELECT s.TOP_ITEM, b.CHILD_ITEM_CODE, s.QTY * b.ITEM_UNIT_QTY
      FROM bsrc s
      JOIN ID_ENG_BOM b
        ON b.ITEM_CODE = s.TOP_ITEM AND b.PARENT_ITEM_CODE = s.NODE
       AND b.ORGANIZATION_ID = :organizationId AND b.CHILD_ITEM_CODE <> b.PARENT_ITEM_CODE
    UNION ALL
    SELECT t.top_item, b.CHILD_ITEM_CODE, t.qty * b.ITEM_UNIT_QTY
      FROM btree t
      JOIN ID_ENG_BOM b
        ON b.ITEM_CODE = t.top_item AND b.PARENT_ITEM_CODE = t.child
       AND b.ORGANIZATION_ID = :organizationId AND b.CHILD_ITEM_CODE <> b.PARENT_ITEM_CODE
  )
  SELECT t.child AS ITEM_CODE, SUM(t.qty) AS QTY
    FROM btree t
   WHERE NOT EXISTS (SELECT 1 FROM ID_ENG_BOM s
                      WHERE s.ITEM_CODE = t.top_item AND s.PARENT_ITEM_CODE = t.child
                        AND s.ORGANIZATION_ID = :organizationId)
     AND NOT EXISTS (SELECT 1 FROM ID_ENG_BOM m
                      WHERE m.ITEM_CODE = t.child AND m.ORGANIZATION_ID = :organizationId)
   GROUP BY t.child`;

/**
 * 실사 입력의 품목별 실사수량. 반제품·제품·박스 입력(WORKSTAGE_CODE = 풀 기준 제품)은 BOM 말단으로 풀고,
 * 자재 입력(WORKSTAGE_CODE = '*')은 그대로 더한다. 결과: ITEM_CODE · QTY. 바인드 :yyyymm · :organizationId.
 */
export const wipCountedSql = `
  SELECT u.ITEM_CODE AS "itemCode", SUM(u.QTY) AS "qty"
    FROM (
      SELECT e.ITEM_CODE, NVL(e.CHECK_INVENTORY_QTY, 0) AS QTY
        FROM IM_ITEM_WS_INVE_CHECK_EXCEL e
       WHERE e.CLOSE_YYYYMM = :yyyymm AND e.ORGANIZATION_ID = :organizationId AND e.WORKSTAGE_CODE = '*'
      UNION ALL
      SELECT x.ITEM_CODE, x.QTY
        FROM (${bomLeafSql(`
          SELECT e.WORKSTAGE_CODE AS TOP_ITEM, e.ITEM_CODE AS NODE, NVL(e.CHECK_INVENTORY_QTY, 0) AS QTY
            FROM IM_ITEM_WS_INVE_CHECK_EXCEL e
           WHERE e.CLOSE_YYYYMM = :yyyymm AND e.ORGANIZATION_ID = :organizationId AND e.WORKSTAGE_CODE <> '*'`)}) x
    ) u
   GROUP BY u.ITEM_CODE`;

/**
 * 장부를 고정한 뒤 제품창고에 입고돼 공정재고에서 빠진 박스 중 실사에서 안 센 것의 자재 몫 (ITEM_CODE · QTY).
 * 고정한 장부에는 이 박스 자재가 들어 있는데 박스는 이미 창고로 갔으니, 비교할 장부에서 뺀다.
 * 센 뒤에 입고된 박스는 실사수량에 들어 있으니 빼지 않는다. 바인드 :yyyymm · :organizationId.
 */
export const wipMovedSql = `(${bomLeafSql(`
  SELECT p.PART_NO AS TOP_ITEM, p.PART_NO AS NODE, p.PACK_QTY AS QTY
    FROM IP_PRODUCT_PACK_MASTER p
   WHERE p.ORGANIZATION_ID = :organizationId
     AND p.RECEIPT_FLAG = 'Y' AND p.WIP_PROCESS_FLAG = 'Y'
     AND p.MODEL_NAME NOT IN ${EXCLUDED_MODELS}
     AND p.WIP_PROCESS_DATE > (SELECT MIN(c.ENTER_DATE) FROM IM_ITEM_WORKSTAGE_INV_CHECK c
                                WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId)
     AND NOT EXISTS (SELECT 1 FROM IM_ITEM_WS_INVE_CHECK_EXCEL e
                      WHERE e.CLOSE_YYYYMM = :yyyymm AND e.ORGANIZATION_ID = :organizationId
                        AND e.ITEM_CODE = p.PART_NO AND e.MFS = ${wipBoxKeySql('p.PACK_BARCODE')})`)})`;

/**
 * 반제품·제품을 품목코드로 셀 때 어느 제품 BOM 으로 풀지 고른다 (생산투입이 그 반제품을 빼는 방식과 같게).
 * - 포장 실적이 있는 제품이면 그 제품 BOM 전체.
 * - 다른 제품 BOM 안의 반제품이면 그 제품 BOM 의 그 반제품 아래. 여러 제품에 쓰이면 가장 최근에 포장한 제품.
 * - 자기 BOM 만 있으면 그것. 어디에도 없으면 null (원자재 — 그대로 센다).
 * @param tops 그 품목을 부모로 가진 BOM 의 제품 목록 (자기 BOM 이면 자기 자신 포함)
 * @param lastPack 제품별 마지막 포장일 (YYYY-MM-DD)
 */
export function pickExplodeTop(item: string, tops: string[], lastPack: Map<string, string>): string | null {
  const own = tops.includes(item);
  if (own && lastPack.has(item)) return item;
  const others = tops.filter((t) => t !== item).sort((a, b) => {
    const la = lastPack.get(a) ?? '';
    const lb = lastPack.get(b) ?? '';
    return la === lb ? a.localeCompare(b) : lb.localeCompare(la);
  });
  if (others.length) return others[0];
  return own ? item : null;
}

/** 품목마다 풀 기준 제품을 찾는다 (없으면 그 품목은 원자재). */
export async function findExplodeTops(q: Queryable, items: string[], organizationId: number) {
  const result = new Map<string, string | null>();
  const unique = [...new Set(items)];
  const topsOf = new Map<string, string[]>();
  for (let i = 0; i < unique.length; i += 500) {
    const chunk = unique.slice(i, i + 500);
    const binds: Record<string, unknown> = { organizationId };
    chunk.forEach((v, j) => { binds[`i${j}`] = v; });
    const rows = (await q.query(
      `SELECT DISTINCT ITEM_CODE AS "top", PARENT_ITEM_CODE AS "node" FROM ID_ENG_BOM
        WHERE ORGANIZATION_ID = :organizationId AND CHILD_ITEM_CODE <> PARENT_ITEM_CODE
          AND PARENT_ITEM_CODE IN (${chunk.map((_, j) => `:i${j}`).join(', ')})`,
      namedBinds(binds),
    )) as Row[];
    for (const r of rows) {
      const list = topsOf.get(String(r.node)) ?? [];
      list.push(String(r.top));
      topsOf.set(String(r.node), list);
    }
  }
  const allTops = [...new Set([...topsOf.values()].flat())];
  const lastPack = new Map<string, string>();
  for (let i = 0; i < allTops.length; i += 500) {
    const chunk = allTops.slice(i, i + 500);
    const binds: Record<string, unknown> = { organizationId };
    chunk.forEach((v, j) => { binds[`t${j}`] = v; });
    const rows = (await q.query(
      `SELECT PART_NO AS "top", TO_CHAR(MAX(PACK_DATE), 'YYYY-MM-DD') AS "lastPack" FROM IP_PRODUCT_PACK_MASTER
        WHERE ORGANIZATION_ID = :organizationId AND PART_NO IN (${chunk.map((_, j) => `:t${j}`).join(', ')})
        GROUP BY PART_NO`,
      namedBinds(binds),
    )) as Row[];
    for (const r of rows) lastPack.set(String(r.top), String(r.lastPack));
  }
  for (const item of unique) result.set(item, pickExplodeTop(item, topsOf.get(item) ?? [], lastPack));
  return result;
}
