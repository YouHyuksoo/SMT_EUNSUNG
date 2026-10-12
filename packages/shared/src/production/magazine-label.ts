/**
 * @file packages/shared/src/production/magazine-label.ts
 * @description 매거진라벨 발행·분할 산술 (프론트 미리보기 · 백엔드 실제 발행 공용).
 *
 * 초보자 가이드:
 * 1. **매거진은 PCB 를 담는 상자다.** 런카드(생산지시) 한 건의 수량을 상자 단위로
 *    나눠 담고, 상자마다 라벨을 한 장 붙인다. 이 파일은 "몇 장을, 각각 몇 개씩"
 *    붙일지를 계산한다.
 * 2. **라벨번호는 9자다** — `라인코드(2) + 날짜코드(3) + 순번(4)`. 실측 최근 1년
 *    42,860건이 전부 9자이고 예시가 `1069S6199` 다 (라인 `10` · 날짜 `69S` · 순번
 *    `6199`). 날짜코드는 `YYYYMMDD` 가 아니라 3글자다 — 자재 롯트번호와 같은 규칙이라
 *    [[reel-plan]] 의 설명을 그대로 쓴다. **접두어는 화면이 만들지 않고 DB 에서 받는다.**
 * 3. **수량이 늘어나면 안 된다.** 발행은 남은 수량을 장입수량만큼 떼어 가는 것이고,
 *    분할은 원본 수량을 조각으로 쪼개는 것이다. 어느 쪽도 합계가 원본을 넘지 않는다 —
 *    그래서 계산을 화면·서버가 같은 함수로 하고 단위테스트로 못 박는다.
 * 4. **라벨 구분은 네 가지지만 현장은 하나만 쓴다** (실측): 전 기간 241,341건이
 *    `P`(정상)이고 `B`(불량)가 4건, `R`(수리)·`D`(폐기)는 0건이다.
 */

/** PB `MAGAZINE_LABEL_TYPE` 값. */
export const MAGAZINE_LABEL_TYPE = {
  /** 정상 — 현장이 실제로 쓰는 유일한 구분 (실측 241,341건). */
  normal: 'P',
  /** 불량(NG) — 실측 4건. */
  bad: 'B',
  /** 수리 — 실측 0건. */
  repair: 'R',
  /** 폐기 — 실측 0건. */
  destroy: 'D',
} as const;

export type MagazineLabelType =
  (typeof MAGAZINE_LABEL_TYPE)[keyof typeof MAGAZINE_LABEL_TYPE];

/**
 * 매거진라벨번호 = 라인코드 + 날짜접두어 + 순번 4자리.
 *
 * PB `LVS_LINE_CODE + F_YMD_SYSDATE() + STRING(F_GET_SEQUENCE(...), '0000')` 그대로다.
 * `datePrefix` 는 DB 에서 받은 3글자 코드이고, 여기서 만들지 않는다.
 */
export function buildMagazineLabelNo(
  lineCode: string,
  datePrefix: string,
  sequence: number | string,
): string {
  return `${lineCode}${datePrefix}${String(sequence).padStart(4, '0')}`;
}

// ───────────────────────────────── 발행 (229)

export interface MagazinePrintInput {
  /** 런카드 지시수량 (`IP_PRODUCT_RUN_CARD.LOT_SIZE`). */
  planQty: number;
  /** 이 런카드로 이미 발행된 수량 (`F_GET_MAGAZINE_QTY_BY_RUN_NO`). */
  magazineQty: number;
  /** 이번에 발행할 정상 수량. */
  okQty: number;
  /** 정상 라벨에 포함시킬 수량 (PB `OK_INCLUDE_QTY`). */
  okIncludeQty?: number;
  /** 불량 수량. */
  ngQty?: number;
  /** 상자 하나에 담는 수량 (`IP_PRODUCT_MODEL_MASTER.MAGAZINE_SIZE`). */
  packingPcsQty: number;
  /** 발행 요청 라벨 장수. */
  printQty: number;
}

export interface MagazineVerdict {
  ok: boolean;
  reason?: string;
}

/**
 * 발행해도 되는지 본다.
 *
 * PB 가 막던 것은 하나다 — **이미 발행된 수량 + 이번 수량이 지시수량을 넘으면 거절**.
 * 여기에 PB 가 검사하지 않아 무한루프가 나던 `장입수량 0` 을 더 막는다
 * (PB 는 `remain` 이 줄지 않아 라벨을 계속 찍었다).
 */
export function checkMagazinePrint(input: MagazinePrintInput): MagazineVerdict {
  const planQty = Number(input.planQty);
  const magazineQty = Number(input.magazineQty ?? 0);
  const okQty = Number(input.okQty ?? 0);
  const ngQty = Number(input.ngQty ?? 0);
  const okIncludeQty = Number(input.okIncludeQty ?? 0);
  const packingPcsQty = Number(input.packingPcsQty ?? 0);
  const printQty = Number(input.printQty ?? 0);

  if (!Number.isFinite(planQty) || planQty <= 0) {
    return { ok: false, reason: '런카드 지시수량을 읽을 수 없습니다.' };
  }
  if (okQty < 0) {
    return { ok: false, reason: '정상 수량이 음수입니다.' };
  }
  if (okQty === 0 && ngQty === 0) {
    return { ok: false, reason: '발행할 수량이 없습니다.' };
  }
  if (magazineQty + okQty + ngQty + okIncludeQty > planQty) {
    return {
      ok: false,
      reason: `발행수량이 지시수량을 넘습니다 (이미 ${magazineQty} + 이번 `
        + `${okQty + ngQty + okIncludeQty} > 지시 ${planQty}).`,
    };
  }
  if (okQty > 0) {
    if (!Number.isFinite(packingPcsQty) || packingPcsQty <= 0) {
      return { ok: false, reason: '장입수량(매거진 크기)이 0 입니다. 모델기준정보를 확인하세요.' };
    }
    if (!Number.isFinite(printQty) || printQty <= 0) {
      return { ok: false, reason: '발행할 라벨 장수를 1 이상으로 넣으세요.' };
    }
  }
  return { ok: true };
}

/**
 * 라벨 한 장씩의 수량을 계산한다.
 *
 * PB 의 `DO … LOOP WHILE (printQty > 0 and remain > 0)` 그대로다 —
 * 남은 수량이 장입수량보다 적으면 **마지막 상자는 남은 만큼만** 담는다.
 * 그래서 반환값의 합은 절대 `okQty` 를 넘지 않는다.
 */
export function planMagazineLabels(input: MagazinePrintInput): number[] {
  const verdict = checkMagazinePrint(input);
  if (!verdict.ok) return [];

  const packing = Number(input.packingPcsQty);
  let remain = Number(input.okQty);
  let sheets = Number(input.printQty);
  const labels: number[] = [];

  while (sheets > 0 && remain > 0) {
    const qty = remain < packing ? remain : packing;
    labels.push(qty);
    remain -= qty;
    sheets -= 1;
  }
  return labels;
}

// ───────────────────────────────── 분할 (230)

export interface MagazineSplitInput {
  /** 원본 라벨의 수량. */
  lotQty: number;
  /** 새 정상 라벨로 떼어낼 수량. */
  divideQty: number;
  /** 불량으로 떼어낼 수량. */
  ngQty?: number;
  /** 폐기로 떼어낼 수량. */
  destroyQty?: number;
}

export interface MagazineSplitPiece {
  labelType: MagazineLabelType;
  qty: number;
}

export interface MagazineSplitPlan {
  pieces: MagazineSplitPiece[];
  /** 조각 수량의 합. 언제나 `lotQty` 와 같다. */
  totalQty: number;
}

/**
 * 나눠도 되는지 본다. PB 는 `lotQty < divide + ng + destroy` 하나만 막았다.
 * 여기에 음수와 '나눌 것이 없는' 경우를 더 막는다.
 */
export function checkMagazineSplit(input: MagazineSplitInput): MagazineVerdict {
  const lotQty = Number(input.lotQty);
  const divideQty = Number(input.divideQty ?? 0);
  const ngQty = Number(input.ngQty ?? 0);
  const destroyQty = Number(input.destroyQty ?? 0);

  if (!Number.isFinite(lotQty) || lotQty <= 0) {
    return { ok: false, reason: '원본 라벨의 수량을 읽을 수 없습니다.' };
  }
  if ([divideQty, ngQty, destroyQty].some((q) => !Number.isFinite(q) || q < 0)) {
    return { ok: false, reason: '분할 수량에 음수를 넣을 수 없습니다.' };
  }
  const taken = divideQty + ngQty + destroyQty;
  if (taken === 0) {
    return { ok: false, reason: '나눌 수량을 넣으세요.' };
  }
  if (taken > lotQty) {
    return {
      ok: false,
      reason: `나눌 수량 합(${taken})이 원본 수량(${lotQty})보다 많습니다.`,
    };
  }
  return { ok: true };
}

/**
 * 원본 라벨을 조각으로 쪼갠다.
 *
 * PB 가 만드는 순서 그대로다 — **잔량 → 분할 → 불량 → 폐기**. 잔량이 0 이면
 * 그 조각은 만들지 않는다. 원본 라벨은 이력표로 옮겨지고 없어지므로,
 * **조각 수량의 합이 원본 수량과 같아야 한다** (이 파일의 핵심 불변식).
 */
export function planMagazineSplit(input: MagazineSplitInput): MagazineSplitPlan {
  const lotQty = Number(input.lotQty);
  const divideQty = Number(input.divideQty ?? 0);
  const ngQty = Number(input.ngQty ?? 0);
  const destroyQty = Number(input.destroyQty ?? 0);
  const remain = lotQty - (divideQty + ngQty + destroyQty);

  const pieces: MagazineSplitPiece[] = [];
  if (remain > 0) pieces.push({ labelType: MAGAZINE_LABEL_TYPE.normal, qty: remain });
  if (divideQty > 0) pieces.push({ labelType: MAGAZINE_LABEL_TYPE.normal, qty: divideQty });
  if (ngQty > 0) pieces.push({ labelType: MAGAZINE_LABEL_TYPE.bad, qty: ngQty });
  if (destroyQty > 0) pieces.push({ labelType: MAGAZINE_LABEL_TYPE.destroy, qty: destroyQty });

  return { pieces, totalQty: pieces.reduce((sum, p) => sum + p.qty, 0) };
}
