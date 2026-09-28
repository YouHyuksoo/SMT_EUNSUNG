/**
 * @file packages/shared/src/warehouse/reel-plan.ts
 * @description 자재 바코드 발행의 릴 분할 규칙 — 프론트·백엔드가 함께 쓴다.
 *
 * 초보자 가이드:
 * 1. **왜 공유 패키지에 있나.** 화면은 "몇 장이 몇 개씩 나오나" 를 발행 전에
 *    보여줘야 하고, 서버는 그 계획대로 넣어야 한다. 규칙을 두 곳에 쓰면 한쪽만
 *    고쳐진다 — 그러면 화면이 보여준 것과 실제로 들어간 것이 달라진다.
 * 2. **PB 235 `w_mat_receipt_slip_master` 의 분할 규칙을 그대로 옮긴 것이다.**
 *    두 갈래가 있다 (PB `cbx_manual_slip` 체크박스):
 *        수동 — 사용자가 수량을 하나씩 적는다. 장수 = 적은 개수, 수량 = 적은 값
 *               (PB `LVL_LOOP = UPPERBOUND(ivl_divide_qty)`)
 *        균등 — 릴 수량만큼 장을 만들고 모두 같은 단위수량을 넣는다
 *               (PB `LVL_LOOP = long(sle_reel_qty.text)`, 수량 = `sle_unit_qty`)
 * 3. **균등인데 단위수량이 비어 있으면 PB 는 거절한다** (실측 928·1049행 두 곳).
 *    그 판정이 없으면 수량 0짜리 바코드가 릴 수만큼 발행된다.
 * 4. **바코드 형식은 `품목코드-롯트번호-수량` 이다** (PB 문자열 연결 그대로).
 *    롯트번호는 3글자 날짜코드 + 시퀀스값이고 **장마다 새로 뽑는다** — 장마다 롯트가
 *    다르다는 뜻이다 (PB 루프 안에서 `F_GET_SEQUENCE('SEQ_MATERIAL_BARCODE')` 를
 *    매번 부른다).
 * 5. **시퀀스와 날짜코드는 이 파일이 만들지 않는다.** 밖에서 받아 쓴다 — 그래야 이 규칙을
 *    DB 없이 테스트할 수 있고, 값은 PB 와 같은 Oracle 시퀀스·함수에서 나온다.
 *    날짜코드는 `SUBSTR(TO_CHAR(SYSDATE,'YYYY'),4,1) || F_GET_MONTH_CODE2(MM)
 *    || F_GET_DAY_CODE(DD)` 로 받는다 — PB `f_ymd_sysdate()` 와 같은 DB 함수다.
 */

/** 한 장의 바코드 계획. */
export interface ReelBarcodePlan {
  /** 롯트번호 (3글자 날짜코드 + 시퀀스). 장마다 다르다. */
  lotNo: string;
  /** 자재 바코드 (`품목코드-롯트번호-수량`). */
  itemBarcode: string;
  /** 이 장에 담기는 수량. */
  scanQty: number;
}

/** 분할 입력. `divideQty` 가 있으면 수동, 없으면 균등이다. */
export interface ReelPlanInput {
  /** 릴 장수 (균등 갈래에서 쓴다). */
  reelQty?: number | null;
  /** 한 장에 담을 수량 (균등 갈래에서 쓴다). */
  unitQty?: number | null;
  /** 장별 수량을 직접 적은 목록 (수동 갈래). 있으면 이 값이 우선한다. */
  divideQty?: readonly number[] | null;
}

export interface ReelPlanVerdict {
  /**
   * 판별 유니온으로 두지 않는다 — 백엔드 tsconfig 가 `strictNullChecks: false` 라
   * 유니온 좁히기가 동작하지 않아 `verdict.reason` 이 컴파일 오류가 된다
   * (추적 대분류에서 실측한 TS2339).
   */
  ok: boolean;
  reason?: string;
}

/** 한 번에 발행할 수 있는 최대 장수. PB 에는 상한이 없어 실수로 수만 장을 만들 수 있었다. */
export const REEL_PLAN_MAX = 1000;

/**
 * 분할 입력이 발행 가능한지 본다. 화면은 이 결과로 발행 버튼을 막고,
 * 서버는 같은 함수로 다시 판정한다.
 */
export function checkReelPlan(input: ReelPlanInput): ReelPlanVerdict {
  const divide = input.divideQty;
  if (divide && divide.length > 0) {
    if (divide.some((q) => !Number.isFinite(q) || q <= 0)) {
      return { ok: false, reason: '분할 수량에 0 이하이거나 숫자가 아닌 값이 있습니다.' };
    }
    if (divide.length > REEL_PLAN_MAX) {
      return {
        ok: false,
        reason: `한 번에 ${REEL_PLAN_MAX}장까지 발행할 수 있습니다 (요청 ${divide.length}장).`,
      };
    }
    return { ok: true };
  }

  const reel = Number(input.reelQty ?? 0);
  if (!Number.isInteger(reel) || reel <= 0) {
    return { ok: false, reason: '릴 장수를 1 이상 넣으세요.' };
  }
  if (reel > REEL_PLAN_MAX) {
    return {
      ok: false,
      reason: `한 번에 ${REEL_PLAN_MAX}장까지 발행할 수 있습니다 (요청 ${reel}장).`,
    };
  }
  // PB 가 두 곳에서 막는 조건이다. 빼면 수량 0짜리 바코드가 릴 수만큼 나온다.
  const unit = Number(input.unitQty ?? 0);
  if (!Number.isFinite(unit) || unit <= 0) {
    return { ok: false, reason: '균등 분할에는 단위수량이 필요합니다.' };
  }
  return { ok: true };
}

/**
 * 장별 수량 목록을 만든다 (시퀀스 없이).
 *
 * 화면이 발행 전에 "몇 장이 몇 개씩" 을 보여줄 때 쓴다.
 * 입력이 발행 가능하지 않으면 빈 배열을 돌려준다 — 판정은 `checkReelPlan` 이 한다.
 */
export function planReelQuantities(input: ReelPlanInput): number[] {
  if (!checkReelPlan(input).ok) return [];
  const divide = input.divideQty;
  if (divide && divide.length > 0) return [...divide];
  return Array.from({ length: Number(input.reelQty) }, () => Number(input.unitQty));
}

/**
 * 롯트번호 = 날짜접두어 + 시퀀스값 (PB `F_YMD_SYSDATE() + STRING(시퀀스)`).
 *
 * **접두어는 `YYYYMMDD` 가 아니라 3글자 코드다.** PB `f_ymd_sysdate()` 본문이
 * `연도끝자리 + F_GET_MONTH_CODE2(월) + F_GET_DAY_CODE(일)` 이다 (실측 `.srf`).
 * 2026-09-28 이면 `69S` 다 — 실제 롯트번호가 8자(`69S` + 5자리 순번)인 것과 맞는다
 * (실측 최근 1년 303,081건이 8자). 그래서 **접두어는 화면이 만들지 않고 DB 에서 받는다.**
 */
export function buildReelLotNo(datePrefix: string, sequence: number | string): string {
  return `${datePrefix}${sequence}`;
}

/** 자재 바코드 = `품목코드-롯트번호-수량` (PB 문자열 연결 그대로). */
export function buildReelBarcode(itemCode: string, lotNo: string, qty: number): string {
  return `${itemCode}-${lotNo}-${qty}`;
}

/**
 * 발행할 바코드 목록을 만든다.
 *
 * @param sequences 장마다 쓸 시퀀스값. **길이가 계획 장수와 같아야 한다** —
 *                  다르면 바코드가 모자라거나 남으므로 오류를 던진다.
 * @throws 입력이 발행 가능하지 않거나 시퀀스 개수가 맞지 않을 때
 */
export function planReelBarcodes(
  input: ReelPlanInput & { itemCode: string; datePrefix: string },
  sequences: readonly (number | string)[],
): ReelBarcodePlan[] {
  const verdict = checkReelPlan(input);
  if (!verdict.ok) throw new Error(verdict.reason);

  const quantities = planReelQuantities(input);
  if (sequences.length !== quantities.length) {
    throw new Error(
      `시퀀스 개수(${sequences.length})가 발행 장수(${quantities.length})와 다릅니다.`,
    );
  }
  return quantities.map((qty, i) => {
    const lotNo = buildReelLotNo(input.datePrefix, sequences[i]);
    return {
      lotNo,
      itemBarcode: buildReelBarcode(input.itemCode, lotNo, qty),
      scanQty: qty,
    };
  });
}

/** 계획의 수량 합. 전표 수량과 맞는지 화면·서버가 비교한다. */
export function totalReelQty(input: ReelPlanInput): number {
  return planReelQuantities(input).reduce((sum, q) => sum + q, 0);
}
