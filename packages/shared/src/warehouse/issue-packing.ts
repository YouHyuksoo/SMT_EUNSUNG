/**
 * @file packages/shared/src/warehouse/issue-packing.ts
 * @description 출고 포장단위 올림 규칙 — 프론트·백엔드가 함께 쓴다 (PB 257).
 *
 * 초보자 가이드:
 * 1. **자재는 포장 단위로만 나간다.** 250개들이 한 봉지짜리 부품을 300개 요청하면
 *    실제로는 500개(2봉지)가 나간다. 그 올림 계산이 이 함수다.
 * 2. **PB `f_get_item_issue_packing_qty` 를 그대로 옮긴 것이다** (DB 에 같은 이름이
 *    **없다** — PB 함수다. 실측).
 * 3. **포장 단위가 없거나 0 이면 요청 수량 그대로 나간다.** 품목 기준정보
 *    `ID_ITEM.ISSUE_PACKING_QTY` 가 그 값이다.
 * 4. **화면이 미리 보여주고 서버가 같은 값을 넣어야 한다.** 규칙을 두 곳에 쓰면
 *    화면이 보여준 수량과 실제로 빠진 재고가 달라진다.
 */

/** PB `truncate(x, 0)` — 0 쪽으로 버린다 (`Math.trunc` 과 같다). */
const truncToZero = (value: number) => Math.trunc(value);

/**
 * 요청 수량을 포장 단위의 배수로 올린다.
 *
 * @param issueQty      요청 수량. 0 이면 0 을 돌려준다 (PB 첫 줄).
 * @param packingQty    포장 단위 (`ID_ITEM.ISSUE_PACKING_QTY`). 없거나 0 이면 올리지 않는다.
 *
 * PB 분기를 그대로 옮겼다:
 *   포장단위 ≥ 요청수량  → 포장단위 한 개 (한 봉지도 다 나간다)
 *   포장단위 < 요청수량  → 버림 배수 × 포장단위, 나머지가 있으면 한 봉지 더
 *
 * **음수 요청에는 쓰면 안 된다.** PB 는 첫 분기(`포장단위 ≥ 요청수량`)에 걸려
 * **양수 포장단위**를 내므로 반납(음수)이 출고(양수)로 뒤집힌다. 값을 PB 와 맞추려고
 * 그대로 두었고, 대신 부르는 쪽(`issue-manage.service.ts`)이 그 조합을 거절한다.
 */
export function applyIssuePacking(
  issueQty: number,
  packingQty?: number | null,
): number {
  const qty = Number(issueQty);
  if (!Number.isFinite(qty) || qty === 0) return 0;

  const packing = Number(packingQty ?? 0);
  if (!Number.isFinite(packing) || packing === 0) return qty;

  if (packing >= qty) return packing;

  const base = truncToZero(qty / packing) * packing;
  // PB `mod(요청, 포장) > 0` — 음수 요청이면 나머지가 0 이하라 더하지 않는다.
  return qty % packing > 0 ? base + packing : base;
}
