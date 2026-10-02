/**
 * @file src/modules/purchase/order-plan.netting.ts
 * @description 478 발주계획 — 소요량에서 재고를 빼고 발주속성으로 올리는 계산 (순수 함수)
 *
 * 초보자 가이드:
 * 1. SQL 이 계획 줄(품목·거래유형·납기·소요량)과 재고 풀, 발주속성을 다 만들어 준다.
 *    여기서는 **순서가 결과를 바꾸는 부분**만 한다 — 같은 자재의 앞 납기 줄이 재고를
 *    먼저 가져가고, 포장단위로 올려 남은 물량은 뒤 줄이 덜 발주하게 넘어간다.
 * 2. DB 를 건드리지 않는 순수 함수라 단위 테스트로 계산을 고정해 둔다.
 * 3. PB(cb_gen_po 커서 순회 + f_get_order_property 'A')와 같은 식이다.
 *    다른 점 하나: 재고 행이 없는 자재에서 올림 잔량을 PB 는 버렸고 여기서는 넘긴다.
 */

export interface NettingLine {
  itemCode: string;
  lineType: string;
  /** 발주비율까지 반영한 소요량 */
  qty: number;
  minQty: number;
  packQty: number;
  badRate: number;
  /** 개수 단위(EA·SET)면 불량 가산을 정수로 */
  countUnit: boolean;
}

export interface NettingOptions {
  /** 재고 가지를 하나라도 켰는가 (PB Apply Inventory). 끄면 차감·발주속성 모두 건너뛴다. */
  applyInventory: boolean;
  /** 발주속성(불량율·최소주문량·포장단위) 적용 */
  applyOrderRule: boolean;
}

export interface NettingResult {
  /** 재고에서 떼어 준 수량 */
  applied: number;
  /** 불량율로 더한 수량 */
  badQty: number;
  /** 최소주문량·포장단위로 더 올린 수량 */
  roundUpQty: number;
  /** 최종 발주량 */
  purchaseQty: number;
}

/** Oracle ROUND 와 같은 반올림 (0.5 는 0 에서 먼 쪽) */
export const roundHalfUp = (value: number, digits: number): number => {
  const f = 10 ** digits;
  return (Math.sign(value) * Math.round(Math.abs(value) * f + 1e-9)) / f;
};

const poolKey = (itemCode: string, lineType: string) => `${itemCode}|${lineType}`;

/**
 * 계획 줄을 앞에서부터 순회하며 재고를 배정한다. `lines` 는 품목·거래유형·납기 순으로
 * 정렬돼 있어야 한다. `pools` 는 품목·거래유형별 가용재고 합(0 이하는 없는 것으로 본다).
 */
export function netOrderLines(
  lines: NettingLine[],
  pools: Map<string, number>,
  options: NettingOptions,
): NettingResult[] {
  const pool = new Map<string, number>();
  for (const [key, qty] of pools) pool.set(key, qty > 0 ? qty : 0);

  return lines.map((line) => {
    if (!options.applyInventory) {
      // PB: Apply Inventory 를 끄면 소요량이 그대로 발주량이다 (발주속성도 안 탄다).
      return { applied: 0, badQty: 0, roundUpQty: 0, purchaseQty: line.qty };
    }

    const key = poolKey(line.itemCode, line.lineType);
    let remain = line.qty;
    let applied = 0;
    const have = pool.get(key) ?? 0;
    if (remain > 0 && have > 0) {
      applied = Math.min(remain, have);
      pool.set(key, have - applied);
      remain -= applied;
    }

    let badQty = 0;
    let calc = remain;
    if (options.applyOrderRule && remain > 0) {
      if (line.badRate !== 0) {
        badQty = roundHalfUp((line.badRate * remain) / 100, line.countUnit ? 0 : 4);
      }
      calc = remain + badQty;
      if (line.minQty > 0 && calc < line.minQty) calc = line.minQty;
      if (line.packQty > 0) {
        if (calc > line.packQty) {
          if (calc % line.packQty > 0) {
            calc = Math.trunc(calc / line.packQty) * line.packQty + line.packQty;
          }
        } else {
          calc = line.packQty;
        }
      }
    }
    // 소요량이 0 이하인 줄은 발주하지 않는다.
    if (calc < 0) calc = 0;

    // 올려서 남는 만큼은 같은 자재의 뒤 줄이 쓰도록 재고 풀에 돌려 놓는다.
    const surplus = calc - remain;
    if (remain > 0 && surplus > 0) {
      pool.set(key, (pool.get(key) ?? 0) + surplus);
    }

    const roundUpQty = remain > 0 ? Math.max(calc - remain - badQty, 0) : 0;
    return { applied, badQty, roundUpQty, purchaseQty: calc };
  });
}
